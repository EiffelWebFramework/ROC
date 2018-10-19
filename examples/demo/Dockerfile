FROM debian
#ubuntu:xenial
MAINTAINER Jocelyn Fiat <jfiat@eiffel.com>
LABEL description="EiffelWeb ROC CMS hosted using apache2+libfcgi"

RUN apt-get update 										\
        && apt-get -y install 							\
			curl bzip2 make gcc git-core 				\
			apache2 libapache2-mod-fcgid libfcgi-dev 	\
			sqlite3 libsqlite3-dev					 	\
			default-libmysqlclient-dev \
        && rm -rf /var/lib/apt/lists/*

#--no-install-recommends 	\
EXPOSE 80

RUN a2enmod rewrite suexec include fcgid

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/eifweb && \
    echo "eifweb:x:${uid}:${gid}:eifweb,,,:/home/eifweb:/bin/bash" >> /etc/passwd && \
    echo "eifweb:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/eifweb

USER eifweb
ENV HOME /home/eifweb
ENV WEBDIR /home/eifweb/www
WORKDIR $HOME

# Create expected folders
RUN mkdir $WEBDIR

#Build the debug EiffelWeb example and copy the executable to $HOME/
COPY ./docker-inc/files/build_service_fcgi $HOME/build_service_fcgi
USER root
RUN chown eifweb:eifweb $HOME/build_service_fcgi && chmod 700 $HOME/build_service_fcgi
USER eifweb
RUN $HOME/build_service_fcgi $HOME/www

USER root
COPY ./docker-inc/files/httpd.conf /etc/apache2/sites-enabled/000-default.conf
ADD ./docker-inc/files/html $WEBDIR/html
ADD ./site $WEBDIR/html/site
RUN mkdir $WEBDIR/html/theme	\
	&& mkdir $WEBDIR/html/site/www \
	&& ln -s $WEBDIR/html/site/files files \
	&& ln -s $WEBDIR/html/site/theme/bootstrap/images images \
	&& ln -s $WEBDIR/html/site/theme/bootstrap/assets bootstrap	\
	&& chown www-data:www-data -R $WEBDIR

#Setup apache as foreground (for docker purpose)
RUN mkdir -p /etc/service/apache
ADD ./docker-inc/files/apache.sh /etc/service/apache/run
RUN chmod +x /etc/service/apache/run
ENTRYPOINT ["/etc/service/apache/run"]
