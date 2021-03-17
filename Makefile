#!/usr/bin/make -f
########################################################################
# Copyright (C) 2021		Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################
SHELL	= /bin/bash

user	= alejandrocolomar
repo	= nginx
img	= $(user)/$(repo):$(shell git describe --tags)
img_	= $(img)_$(shell uname -m)

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
	@docker manifest create '$(img)' '$(img)_x86_64' '$(img)_arm64';

.PHONY: manifest-push
manifest-push:
	@echo '	DOCKER manifest push	$(img)';
	@docker manifest push '$(img)';
