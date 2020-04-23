FROM node:10.7.0-alpine

ENV ACCEPT_HIGHCHARTS_LICENSE="YES" \
	PHANTOMJS_CDNURL="http://cnpmjs.org/downloads" 

USER 0
RUN apk add --update make gcc g++ python git curl lzip wget ffmpeg libjpeg-turbo-dev libpng-dev libtool libgomp fontconfig yarn \
	&& curl -Ls "https://github.com/dustinblackman/phantomized/releases/download/2.1.1a/dockerized-phantomjs.tar.gz" | tar xz -C / \
	&& apk add --update py-pip unzip \
	&& wget "https://netix.dl.sourceforge.net/project/graphicsmagick/graphicsmagick/1.3.35/GraphicsMagick-1.3.35.tar.lz" \
	&& lzip -d -c GraphicsMagick-1.3.35.tar.lz | tar -xvf - \
    	&& cd GraphicsMagick-1.3.35 \
    	&& ./configure \
		--build=$CBUILD \
		--host=$CHOST \
		--prefix=/usr \
		--sysconfdir=/etc \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--localstatedir=/var \
		--enable-shared \
		--disable-static \
		--with-modules \
		--with-threads \
		--with-gs-font-dir=/usr/share/fonts/Type1 \
		--with-quantum-depth=16 \
    	&& make && make install \
    	&& cd .. && rm -rf GraphicsMagick-1.3.35 && rm GraphicsMagick-1.3.35.tar.lz \
	&& rm -rf /usr/share/man /tmp/* /var/tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
	&& yarn global add highcharts-export-server \
	&& mkdir -p /usr/share/fonts/truetype/ 
	
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-Regular.ttf /usr/share/fonts/truetype/OpenSans-Regular.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-Light.ttf /usr/share/fonts/truetype/OpenSans-Light.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-Semibold.ttf /usr/share/fonts/truetype/OpenSans-Semibold.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-Bold.ttf /usr/share/fonts/truetype/OpenSans-Bold.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-ExtraBold.ttf /usr/share/fonts/truetype/OpenSans-ExtraBold.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-Italic.ttf /usr/share/fonts/truetype/OpenSans-Italic.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-LightItalic.ttf /usr/share/fonts/truetype/OpenSans-LightItalic.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-BoldItalic.ttf /usr/share/fonts/truetype/OpenSans-BoldItalic.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-SemiboldItalic.ttf /usr/share/fonts/truetype/OpenSans-SemiboldItalic.ttf
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts/OpenSans-ExtraBoldItalic.ttf /usr/share/fonts/truetype/OpenSans-ExtraBoldItalic.ttf	

WORKDIR /
EXPOSE 8080
ENTRYPOINT ["highcharts-export-server", "--enableServer", "1", "--port", "8080", "--workers", "16"] 
