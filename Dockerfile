# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: qsymond <qsymond@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/07/02 19:09:09 by qsymond           #+#    #+#              #
#    Updated: 2020/07/02 19:34:30 by qsymond          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
LABEL maintainer="qsymond@student.21-school.ru"

#ADD ALL CONF FILES
COPY srcs/* ./home/

#ADD ALL NEEDED APT
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install nginx
RUN apt-get -y install wget
RUN apt-get -y install mariadb-server
RUN apt-get -y install php php-mysql php-fpm php-cli php-mbstring php-zip php-gd

#CONF WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar xvf latest.tar.gz
RUN rm -rf latest.tar.gz
RUN mv ./home/wp-config.php wordpress

#CONF PHPMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN tar xvf phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN rm -rf phpMyAdmin-4.9.0.1-all-languages.tar.gz

#CONF NGINX
RUN rm -rf /etc/nginx/sites-enabled/default
RUN cp ./home/nginx.conf /etc/nginx/sites-enabled/localhost

#CONF MARIADB
RUN bash ./home/mysql.sh

#SORT INDEX
RUN mv phpMyAdmin-4.9.0.1-all-languages/ /var/www/html/phpmyadmin
RUN mkdir /var/www/html/accueil
RUN mv /var/www/html/index.nginx-debian.html /var/www/html/accueil/
RUN mv wordpress /var/www/html

#CERTIFICATION SSL
RUN	openssl req -x509 -nodes -days 14 -newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=RU/ST=Moscow/L=Moscow/O=School 21/CN=Qsymond"

#LANCEMENT && BOUCLE
RUN chmod +x ./home/autoindex.sh
CMD bash ./home/start.sh

EXPOSE 80 443