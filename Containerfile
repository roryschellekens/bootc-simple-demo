FROM quay.io/fedora/fedora-bootc:41

LABEL org.opencontainers.image.source="https://github.com/roryschellekens/bootc-simple-demo"
LABEL org.opencontainers.image.description="Bootc Simple Demo for Bright Cubes Lunch & Learn"
LABEL org.opencontainers.image.license="MIT"

#include unit files and containers
ADD etc etc

RUN ln -s /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

# Insert RPM packages here
RUN dnf install -y cloud-init

RUN bootc container lint
