#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash


arch	= $(shell uname -m)

reg	= docker.io
user	= alejandrocolomar
repo	= nginx
lbl	= $(shell git describe --tags | sed 's/^v//')
lbl_	= $(lbl)_$(arch)
img	= $(reg)/$(user)/$(repo):$(lbl)
img_	= $(reg)/$(user)/$(repo):$(lbl_)


Dockerfile: $(CURDIR)/etc/docker/dependencies/nginx
Dockerfile: $(CURDIR)/libexec/update_dockerfile
	@echo '	Update Dockerfile ARGs';
	@$<;

.PHONY: image
image: Dockerfile
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
