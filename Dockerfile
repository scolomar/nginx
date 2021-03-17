########################################################################
#	Copyright (C) 2020        Sebastian Francisco Colomar Bauza
#	Copyright (C) 2020, 2021  Alejandro Colomar <alx.manpages@gmail.com>
#	SPDX-License-Identifier:  GPL-2.0-only OR LGPL-2.0-only
########################################################################


########################################################################
ARG	NGINX_REG
ARG	NGINX_USER
ARG	NGINX_REPO
ARG	NGINX_LBL
ARG	NGINX_DIGEST
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
