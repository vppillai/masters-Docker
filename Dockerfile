FROM ubuntu:16.04
MAINTAINER vysakhpillai@gmail.com

RUN apt-get update && apt-get install -y openssh-server apache2 supervisor mosquitto-clients mosquitto build-essential vim 
RUN mkdir -p /var/lock/apache2 /var/run/apache2 /var/run/sshd /var/log/supervisor /var/lock/mosquitto /var/run/mosquitto

#apis
RUN mkdir -p /var/www/api/listen
COPY listen.sh /var/www/api/listen/to
RUN chmod +x /var/www/api/listen/to

RUN mkdir -p /var/www/api/mdtweet
COPY  sendMessage.c /var/www/api/mdtweet
RUN gcc /var/www/api/mdtweet/sendMessage.c -o /var/www/api/mdtweet/for
run rm /var/www/api/mdtweet/sendMessage.c

#apache
COPY serve-cgi-bin.conf /etc/apache2/conf-available/serve-cgi-bin.conf
COPY serve-cgi-bin.conf /etc/apache2/conf-enabled/serve-cgi-bin.conf
COPY apache2.conf /etc/apache2/apache2.conf
RUN a2enmod cgi

COPY mosquitto.conf /etc/mosquitto/mosquitto.conf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 80 443
CMD ["/usr/bin/supervisord"]
