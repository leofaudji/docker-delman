# Import from ubuntu official
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# Install all application
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    tzdata \
    apache2-utils \
    php-cli \
    php-curl \
    php-xml \
    php-gd \
    php-bcmath \
    php-mbstring \
    php-zip \
    php-redis \
    php-mysql \
    rsync \
    openssh-client \
    rsyslog \
    cron \
    nano \
    joe \
    net-tools \
    iputils-ping \
    htop \
    stress \
    libapache2-mod-php \
    wget \
    nfs-common \
    iptables \
    tcpdump \
    strongswan \
    xl2tpd \
    wireguard \
    lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# COPY for config ipsec and xl2tpd
COPY ./etc/ipsec.conf /etc/ipsec.conf
COPY ./etc/ipsec.secrets /etc/ipsec.secrets
COPY ./etc/xl2tpd/xl2tpd.conf /etc/xl2tpd/xl2tpd.conf
COPY ./etc/ppp/options.xl2tpd /etc/ppp/options.xl2tpd
COPY ./etc/ppp/chap-secrets /etc/ppp/chap-secrets
 
# Enable IP forwarding
COPY ./etc/sysctl.conf /etc/sysctl.conf
#COPY ./etc/ufw/before.rules /etc/ufw/before.rules

# COPY for Wireguard
COPY ./etc/wireguard/private.key /etc/wireguard/private.key
COPY ./etc/wireguard/public.key /etc/wireguard/public.key
COPY ./etc/wireguard/wg0.cnf /etc/wireguard/wg0.cnf


# Startup
COPY ./bash.sh /usr/lib/start-server/bash.sh

CMD ["/bin/bash", "-c", "/usr/lib/start-server/bash.sh"]
