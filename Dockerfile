FROM node:10.7.0-alpine

ENV ACCEPT_HIGHCHARTS_LICENSE="YES" \
	PHANTOMJS_CDNURL="http://cnpmjs.org/downloads" 

USER 0
RUN apk add --no-cache --allow-untrusted -f  --force-broken-world --clean-protected -u -U -l -q -v py-pip unzip apk-tools \
		fontconfig ttf-dejavu make gcc g++ python git curl lzip wget ffmpeg libjpeg-turbo-dev libpng-dev libtool libgomp yarn \
	&& wait \
	&& curl -Ls "https://github.com/dustinblackman/phantomized/releases/download/2.1.1a/dockerized-phantomjs.tar.gz" | tar xz -C / \
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
	&& yarn global add highcharts-export-server@2.0.28 \
	&& yarn global upgrade --latest \
	&& apk del --no-cache --allow-untrusted -f  --force-broken-world --clean-protected -u -U -l -q -v --purge py-pip unzip apk-tools \
		make gcc g++ python git lzip ffmpeg libjpeg-turbo-dev libpng-dev libtool libgomp \
	&& rm -rf /usr/local/share/.cache/yarn/v1/* /tmp* /usr/share/man /tmp/* \
		/var/tmp/* /var/cache/apk/* /root/.npm /root/.node-gyp /usr/lib/node_modules/npm/man \
		/usr/lib/node_modules/npm/doc /usr/lib/node_modules/npm/html \
	&& mkdir -p /usr/share/fonts/truetype/ 
	
ADD https://github.com/ONSdigital/highcharts-export-docker/blob/master/fonts /usr/share/fonts/truetype	

WORKDIR /
EXPOSE 8080
ENTRYPOINT ["highcharts-export-server", "--enableServer", "1", "--port", "8080", "--workers", "16"] 
#
