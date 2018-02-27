
#		Dockerfile	2.6.37	2018-02-26_20:10:10_CST uadmin three-rpi3b.cptx86.com 2.5-1-gf452ccf 
#		   start working Dockerfile 
FROM armhf/alpine:3.5

RUN apk add --update nginx

COPY create-message.sh /run/create-message.sh

CMD ["/run/create-message.sh"]

