FROM node:9-alpine

ENV ACCEPT_HIGHCHARTS_LICENSE="YES"
USER root
WORKDIR /root/
RUN apk add --update --no-cache --allow-untrusted -f --clean-protected -u -l -q -v py-pip unzip npm make gcc g++ python git curl lzip wget ffmpeg libjpeg-turbo-dev libpng-dev libtool libgomp \
	&& rm -rf /var/cache/apk/* \ 
	&& wait \
	&& ln -s `which nodejs` /usr/bin/node \
	&& npm i npm@latest -g \
	&& git clone https://github.com/highcharts/node-export-server \
	&& cd node-export-server \
    	&& npm install \
    	&& npm link \
	&& curl -Ls "https://github.com/dustinblackman/phantomized/releases/download/2.1.1a/dockerized-phantomjs.tar.gz" | tar xz -C / 
#	&& rm -rf /tmp/* 

COPY ["./fonts/*","/usr/share/fonts/truetype/"]
WORKDIR /

EXPOSE 8080
ENTRYPOINT ["highcharts-export-server", "--enableServer", "1", "--port", "8080", "--workers", "16"] 
