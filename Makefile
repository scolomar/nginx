#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash

registry= docker.io
user	= alejandrocolomar
repo	= nginx
label	= $(shell git describe --tags | sed 's/^v//')
label_	= $(label)_$(shell uname -m)
img	= $(registry)/$(user)/$(repo):$(label)
img_	= $(registry)/$(user)/$(repo):$(label_)

.PHONY: image
image:
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
