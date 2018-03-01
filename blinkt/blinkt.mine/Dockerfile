FROM resin/rpi-raspbian:jessie

RUN apt-get update -qy && apt-get install -qy \
    python2.7 \
    python-rpi.gpio

RUN curl https://get.pimoroni.com/blinkt | /bin/bash

# Cancel out any Entrypoint already set in the base image.
ENTRYPOINT []	

WORKDIR /root/

WORKDIR /root/
COPY set_pixel01.py set_pixel01.py
WORKDIR /root/

CMD ["python", "set_pixel01.py"]

