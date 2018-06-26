
#		Dockerfile  3.07.82  2018-03-05_19:57:10_CST  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.06-3-g39a0ee9  
#		   create-message.sh change directory for /usr/local/data/cluster-1 
#		Dockerfile	2.6.38	2018-02-26_21:15:17_CST uadmin three-rpi3b.cptx86.com 2.6 
#		   first pass at Dockerfile 
#		Dockerfile	2.6.37	2018-02-26_20:10:10_CST uadmin three-rpi3b.cptx86.com 2.5-1-gf452ccf 
#		   start working Dockerfile 
#	--rm -v /usr/local/data:/usr/local/data/ 
#	FROM resin/raspberry-pi-alpine                  # The bare bones Alpine Linux OS image for Ras
FROM resin/rpi-raspbian

LABEL MAINTAINER Bradley Allen

RUN mkdir -p /usr/local/data/cluster-1

RUN apt-get update \
    && apt-get install 

COPY create-message.sh /run/create-message.sh

ENTRYPOINT ["/run/create-message.sh"]

