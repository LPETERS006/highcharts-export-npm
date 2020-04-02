FROM node:10.7.0-alpine

ENV ACCEPT_HIGHCHARTS_LICENSE="YES"
USER root
WORKDIR /root/
RUN apk add --update make gcc g++ python git curl lzip wget ffmpeg libjpeg-turbo-dev libpng-dev libtool libgomp \
	&& curl -Ls "https://github.com/dustinblackman/phantomized/releases/download/2.1.1a/dockerized-phantomjs.tar.gz" | tar xz -C / \
	&& apk add --update py-pip unzip \
	&& ln -s `which nodejs` /usr/bin/node \
	&& git clone https://github.com/highcharts/node-export-server \
	&& cd node-export-server \
    	&& npm install \
    	&& npm link 

#COPY ["./fonts/*","/usr/share/fonts/truetype/"]
WORKDIR /

EXPOSE 8080
ENTRYPOINT ["highcharts-export-server", "--enableServer", "1", "--port", "8080", "--workers", "16"] 
