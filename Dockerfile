################################################################################
##      Copyright (C) 2020        Sebastian Francisco Colomar Bauza           ##
##      Copyright (C) 2020        Alejandro Colomar Andrés                    ##
##      SPDX-License-Identifier:  GPL-2.0-only                                ##
################################################################################


#########################################################################
ARG									\
	tag="1.19.0-alpine@sha256:ee5a9b68e8d4a4b8b48318ff08ad5489bd1ce52b357bf48c511968a302bc347b"
FROM									\
	nginx:$tag							\
		AS nginx
#########################################################################
RUN									\
	for package in							\
		$(							\
			for x in 0 1 2 3 4 5 6 7 8 9;			\
			do						\
				apk list				\
					| awk /nginx/'{ print $1 }'	\
					| awk -F-$x  '{ print $1 }'	\
					| grep -v '\-[0-9]';		\
			done						\
				| sort					\
				| uniq					\
				| grep -v ^nginx$			\
		);							\
	do								\
		apk del $package;					\
	done
#########################################################################
RUN									\
	rm -f	/etc/nginx/nginx.conf					&& \
	ln -svT	/run/configs/etc/nginx/nginx.conf			\
		/etc/nginx/nginx.conf					&& \
	rm -rf	/etc/nginx/conf.d					&& \
	ln -svT	/run/configs/etc/nginx/conf.d				\
		/etc/nginx/conf.d
#########################################################################
