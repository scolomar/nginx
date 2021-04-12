#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################

# Do not print "Entering directory ..."
MAKEFLAGS += --no-print-directory

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
lbl_a	= $(lbl)_$(arch)
img	= $(repository):$(lbl)
img_a	= $(repository):$(lbl_a)
archs	= $(shell <$(CURDIR)/.config grep '^archs' | cut -f2 | tr ',' ' ')
imgs	= $(addprefix $(img)_,$(archs))

config		= $(CURDIR)/.config
orchestrator	= $(shell <$(config) grep '^orchest' | cut -f2)
project		= $(shell <$(config) grep '^project' | cut -f2)
stability	= $(shell <$(config) grep '^stable' | cut -f2)
stack		= $(project)-$(stability)
node_role	= $(shell <$(config) grep '^node' | cut -f2)
host_port	= $(shell <$(config) grep '^port' | grep '$(stability)' | cut -f3)

.PHONY: all
all: image

.PHONY: Dockerfile
Dockerfile: $(CURDIR)/etc/docker/images/nginx
	@echo '	Update Dockerfile ARGs';
	@sed -i \
		-e '/^ARG	NGINX_REG=/s/=.*/="$(nginx_reg)"/' \
		-e '/^ARG	NGINX_USER=/s/=.*/="$(nginx_user)"/' \
		-e '/^ARG	NGINX_REPO=/s/=.*/="$(nginx_repo)"/' \
		-e '/^ARG	NGINX_LBL=/s/=.*/="$(nginx_lbl)"/' \
		-e '/^ARG	NGINX_DIGEST=/s/=.*/="$(nginx_digest)"/' \
		$(CURDIR)/$@;

.PHONY: image
image:
	@$(MAKE) image-build;
	@$(MAKE) image-push;

.PHONY: image-build
image-build: Dockerfile $(nginx_alx)
	@echo '	DOCKER image build	$(img_a)';
	@docker image build -t '$(img_a)' $(CURDIR) >/dev/null;

.PHONY: image-push
image-push:
	@echo '	DOCKER image push	$(img_a)';
	@docker image push '$(img_a)' >/dev/null;

.PHONY: image-manifest
image-manifest:
	@$(MAKE) image-manifest-create;
	@$(MAKE) image-manifest-push;

.PHONY: image-manifest-create
image-manifest-create:
	@echo '	DOCKER manifest create	$(img)';
	@docker manifest create '$(img)' $(imgs) >/dev/null;

.PHONY: image-manifest-push
image-manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)' >/dev/null;

.PHONY: stack-deploy
stack-deploy:
	@echo '	STACK deploy';
	@export node_role='$(node_role)'; \
	export label='$(lbl_a)'; \
	export host_port='$(host_port)'; \
	alx_stack_deploy -o '$(orchestrator)' '$(stack)';

.PHONY: stack-rm
stack-rm:
	@echo '	STACK rm';
	@alx_stack_delete -o '$(orchestrator)' '$(stack)';
