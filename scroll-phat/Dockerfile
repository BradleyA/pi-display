
#		Dockerfile	2.6.38	2018-02-26_21:15:17_CST uadmin three-rpi3b.cptx86.com 2.6 
#		   first pass at Dockerfile 
#		Dockerfile	2.6.37	2018-02-26_20:10:10_CST uadmin three-rpi3b.cptx86.com 2.5-1-gf452ccf 
#		   start working Dockerfile 
#	--rm -v /usr/local/data:/usr/local/data/ 
FROM resin/rpi-raspbian

LABEL MAINTAINER Bradley Allen

RUN mkdir -p /usr/local/data/cluster-1

RUN apt-get update \
    && apt-get install 

COPY create-message.sh /run/create-message.sh

CMD ["/run/create-message.sh"]

