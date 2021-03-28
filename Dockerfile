########################################################################
# Copyright (C) 2020		Sebastian Francisco Colomar Bauza
# Copyright (C) 2020, 2021	Alejandro Colomar <alx.manpages@gmail.com>
# SPDX-License-Identifier:	GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	NGINX_REG="docker.io"
ARG	NGINX_USER="library"
ARG	NGINX_REPO="nginx"
ARG	NGINX_REPOSITORY="${NGINX_REG}/${NGINX_USER}/${NGINX_REPO}"
ARG	NGINX_LBL="1.19.8-alpine"
ARG	NGINX_DIGEST="sha256:96419b83f29b198ae9f63670d5a28325a8bc9ebaf76c1260cf15eca3a521ebd0"
########################################################################
FROM	"${NGINX_REPOSITORY}:${NGINX_LBL}@${NGINX_DIGEST}" AS nginx
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
