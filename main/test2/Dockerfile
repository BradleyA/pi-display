###
#		Dockerfile  3.20.119  2018-06-29_10:01:07_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.19  
#		   create blinkt color color functions 
#		Dockerfile  3.13.110  2018-06-26_11:28:57_CDT  https://github.com/BradleyA/pi-display  uadmin  four-rpi3b.cptx86.com 3.12-6-gfac86bc  
#		   add maintainer 
#		Dockerfile  3.09.86  2018-06-24_22:25:49_CDT  https://github.com/BradleyA/pi-display  uadmin  two-rpi3b.cptx86.com 3.08  
#		   completed prototype controling blinkt from container start with docker-compose 
FROM blinkt
LABEL MAINTAINER Bradley Allen
COPY warn_colors_3.py .
CMD ["python", "warn_colors_3.py"]
