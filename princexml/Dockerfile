# Create an image with princexml installed

FROM ubuntu:18.04
WORKDIR /
RUN apt-get update && apt-get install -y wget
RUN apt-get install -y libcurl4 \
        libfontconfig1 \
        libfreetype6 \
        libgif7 \
        libgomp1 \
        libjpeg8 \
        liblcms2-2 \
        libpixman-1-0 \
        libpng16-16 \
        libtiff5 \
        libxml2
ENV PRINCE_DEB=prince_12.4-1_ubuntu18.04_amd64.deb
RUN wget http://www.princexml.com/download/$PRINCE_DEB && \
    dpkg -i $PRINCE_DEB && \
    rm -f $PRINCE_DEB
RUN mkdir /out
WORKDIR /out
