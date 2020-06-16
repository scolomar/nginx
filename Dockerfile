################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
ARG	port="8080"
################################################################################
FROM	"nginx:1.19.0-alpine"	AS nginx
################################################################################
RUN									\
	for package in $(						\
			for x in 0 1 2 3 4 5 6 7 8 9; do		\
				apk list				\
				| awk /nginx/'{ print $1 }'		\
				| awk -F-$x  '{ print $1 }'		\
				| grep -v '\-[0-9]';			\
			done						\
			| sort						\
			| uniq						\
			| grep -v ^nginx$				\
	); do								\
		apk del $package;					\
	done

################################################################################
RUN									\
	rm -fv	/etc/nginx/nginx.conf					&& \
	ln -svT	/run/configs/etc/nginx/nginx.conf			\
		/etc/nginx/nginx.conf					&& \
	rm -frv	/etc/nginx/conf.d/*					&& \
	ln -svT	/run/configs/etc/nginx/conf.d/configs			\
		/etc/nginx/conf.d/configs				&& \
	ln -svT	/run/secrets/etc/nginx/conf.d/secrets			\
		/etc/nginx/conf.d/secrets

################################################################################
EXPOSE	${port}
################################################################################
