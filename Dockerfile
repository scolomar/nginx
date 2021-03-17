########################################################################
#	Copyright (C) 2020        Sebastian Francisco Colomar Bauza
#	Copyright (C) 2020, 2021  Alejandro Colomar <alx.manpages@gmail.com>
#	SPDX-License-Identifier:  GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	NGINX_REG=docker.io
ARG	NGINX_USER=library
ARG	NGINX_REPO=nginx
ARG	NGINX_LBL=stable-alpine
ARG	NGINX_DIGEST=sha256:0c56c40f232f41c1b8341c3cc055c8b528cb6decefd7f7c8506e2d30bb9678b6
########################################################################
FROM	"${NGINX_REG}/${NGINX_USER}/${NGINX_REPO}:${NGINX_LBL}@${NGINX_DIGEST}" \
	AS nginx
########################################################################
RUN									\
	apk list							\
	|grep 'nginx'							\
	|cut -d' ' -f1							\
	|sed 's/-[0-9].*//'						\
	|sort								\
	|uniq								\
	|grep -v '^nginx$'						\
	|xargs apk del;

########################################################################
RUN	rm -frv	/etc/nginx/conf.d/default.conf;
########################################################################
VOLUME									\
	/var/cache/nginx						\
	/var/run

########################################################################
