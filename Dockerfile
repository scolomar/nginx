################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


################################################################################
FROM	"nginx:1.19.1-alpine"	AS nginx
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
	ln -svT	/usr/local/etc/nginx/nginx.conf				\
		/etc/nginx/nginx.conf					&& \
	rm -frv	/etc/nginx/conf.d					&& \
	ln -svT	/usr/local/etc/nginx/conf.d				\
		/etc/nginx/conf.d

################################################################################
