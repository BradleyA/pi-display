###
#		blinkt/Dockerfile  3.375.571  2019-01-23T22:33:14.743987-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.374  
#		   debuging docker container 
#		blinkt/Dockerfile  3.370.560  2019-01-23T20:58:14.522812-06:00 (CST)  https://github.com/BradleyA/pi-display  uadmin  six-rpi3b.cptx86.com 3.369  
#		   testing led 
#		Dockerfile  3.22.121  2018-07-03_17:30:04_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.21  
#		   add LOCAL-HOST link to local host data in /usr/local/data/cluster 
#		Dockerfile  3.20.119  2018-06-29_10:01:07_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.19  
#		   create blinkt color color functions 
#		Dockerfile  3.13.110  2018-06-26_11:28:57_CDT  https://github.com/BradleyA/pi-display  uadmin  four-rpi3b.cptx86.com 3.12-6-gfac86bc  
#		   add maintainer 
#		Dockerfile  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
#		   completed prototype controling blinkt from container start with docker-compose 
###
#	docker build -t display-led-test .
#	docker run -d -v /sys:/sys --name display-led-test display-led-test
FROM brimstone/blinktd
LABEL MAINTAINER Bradley Allen
COPY display-led-test.py .
CMD ["python", "display-led-test.py"]
