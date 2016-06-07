A debian docker image to test the docker image vulnerability scanners

#Vulnerabilities list

This image contains multiple vulnerable binaries/libraries
* debian jessie base image
* bash => shellshock
* image magick => image tragick
* tomcat
* nodejs
* openssl

#Build the image

```
git clone https://github.com/hexfred/debian.compiler
cd debian.compiler
make
git clone https://github.com/hexfred/debian.vulnlab
cd debian.vulnlab
make
```
