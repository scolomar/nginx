#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash


arch	= $(shell uname -m)

nginx_conf	= $(CURDIR)/etc/docker/dependencies/nginx
nginx_reg	= $(shell <$(nginx_conf) grep reg | cut -f2)
nginx_user	= $(shell <$(nginx_conf) grep user | cut -f2)
nginx_repo	= $(shell <$(nginx_conf) grep repo | cut -f2)
nginx_lbl	= $(shell <$(nginx_conf) grep lbl | cut -f2)
nginx_digest	= $(shell <$(nginx_conf) grep digest | grep $(arch) | cut -f3)

reg	= docker.io
user	= alejandrocolomar
repo	= nginx
lbl	= $(shell git describe --tags | sed 's/^v//')
lbl_	= $(lbl)_$(arch)
img	= $(reg)/$(user)/$(repo):$(lbl)
img_	= $(reg)/$(user)/$(repo):$(lbl_)

.PHONY: image
image:
	@echo '	DOCKER image build	$(img_)';
	@docker image build -t '$(img_)' \
			--build-arg 'NGINX_REG=$(nginx_reg)' \
			--build-arg 'NGINX_USER=$(nginx_user)' \
			--build-arg 'NGINX_REPO=$(nginx_repo)' \
			--build-arg 'NGINX_LBL=$(nginx_lbl)' \
			--build-arg 'NGINX_DIGEST=$(nginx_digest)' \
			$(CURDIR);

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
