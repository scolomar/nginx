#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################

arch	= $(shell uname -m)

nginx		= $(CURDIR)/etc/docker/images/nginx
nginx_reg	= $(shell <$(nginx) grep '^reg' | cut -f2)
nginx_user	= $(shell <$(nginx) grep '^user' | cut -f2)
nginx_repo	= $(shell <$(nginx) grep '^repo' | cut -f2)
nginx_lbl	= $(shell <$(nginx) grep '^lbl' | cut -f2)
nginx_digest	= $(shell <$(nginx) grep '^digest' | grep '$(arch)' | cut -f3)

nginx_alx = $(CURDIR)/etc/docker/images/nginx_alx
reg	= $(shell <$(nginx_alx) grep '^reg' | cut -f2)
user	= $(shell <$(nginx_alx) grep '^user' | cut -f2)
repo	= $(shell <$(nginx_alx) grep '^repo' | cut -f2)
repository = $(reg)/$(user)/$(repo)
lbl	= $(shell git describe --tags | sed 's/^v//')
lbl_	= $(lbl)_$(arch)
img	= $(repository):$(lbl)
img_	= $(repository):$(lbl_)

.PHONY: all
all: image

.PHONY: Dockerfile
Dockerfile: $(CURDIR)/etc/docker/images/nginx
	@echo '	Update Dockerfile ARGs';
	@sed -i \
		-e '/^ARG	NGINX_REG=/s/=.*/=$(nginx_reg)/' \
		-e '/^ARG	NGINX_USER=/s/=.*/=$(nginx_user)/' \
		-e '/^ARG	NGINX_REPO=/s/=.*/=$(nginx_repo)/' \
		-e '/^ARG	NGINX_LBL=/s/=.*/=$(nginx_lbl)/' \
		-e '/^ARG	NGINX_DIGEST=/s/=.*/=$(nginx_digest)/' \
		$(CURDIR)/$@;

.PHONY: image
image: Dockerfile $(nginx_alx)
	@echo '	DOCKER image build	$(img_)';
	@docker image build -t '$(img_)' $(CURDIR);

.PHONY: image-push
image-push:
	@echo '	DOCKER image push	$(img_)';
	@docker image push '$(img_)'; 

.PHONY: manifest
manifest:
	@echo '	DOCKER manifest create	$(img)';
	@docker manifest create '$(img)' '$(img)_x86_64' '$(img)_aarch64';

.PHONY: manifest-push
manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)';
