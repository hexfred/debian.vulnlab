FROM     debian:jessie
MAINTAINER hexfred

# Install the vulnerable bash compiled in an other container
ADD deps/shellshock.tgz /bin/

# Install the vulnerable image tragick compiled in an other container
ADD deps/imagetragick.tgz /usr/local
RUN \
    apt-get -y update && \
    apt-get -y install libgcc-4.9-dev \
		libfontconfig1 libfreetype6 \
        libjbig0 libjpeg62-turbo libpng12-0 libtiff5 \ 
        libwebp5 libwmf0.2-7 libxml2 fftw2 libopenjp2-7 \
        libopenexr6 libpango1.0 librsvg2-2 liblzma5 libltdl7 liblqr-1-0 liblcms2-2
ENV LD_LIBRARY_PATH=/usr/local/lib

# Install the vulnerable tomcat
ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.10
ENV CATALINA_HOME /home/bob/tomcat

RUN \
    apt-get -y update && \
    apt-get -y install openjdk-7-jdk wget && \
    wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

# Install the vulnerable nodejs
ENV NODEJS_VERSION v0.10.27

RUN \
    apt-get -y update && \
    apt-get -y install build-essential && \
    cd /tmp && \
    wget http://nodejs.org/dist/${NODEJS_VERSION}/node-${NODEJS_VERSION}.tar.gz && \
    tar xvzf node-${NODEJS_VERSION}.tar.gz && \
    rm -f node-${NODEJS_VERSION}.tar.gz && \
    cd node-v* && \
    ./configure && \
    CXX="g++ -Wno-unused-local-typedefs" make && \
    CXX="g++ -Wno-unused-local-typedefs" make install && \
    cd /tmp && \
    rm -rf /tmp/node-v* && \
    npm install -g npm && \
    printf '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

# Install the vulnerable openssl
RUN \
    cd /tmp && \
    wget -q http://security.debian.org/pool/updates/main/o/openssl/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    wget -q http://security.debian.org/pool/updates/main/o/openssl/openssl_0.9.8o-4squeeze14_amd64.deb && \
    dpkg -i /tmp/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    dpkg -i /tmp/openssl_0.9.8o-4squeeze14_amd64.deb && \
    rm /tmp/libssl0.9.8_0.9.8o-4squeeze14_amd64.deb && \
    rm /tmp/openssl_0.9.8o-4squeeze14_amd64.deb

