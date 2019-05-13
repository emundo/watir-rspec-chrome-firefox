FROM ubuntu:rolling

ENV HEADLESS true

# Verwende die letzte Chromium-Version.
# => https://launchpad.net/~canonical-chromium-builds/+archive/ubuntu/stage 
RUN apt-get update -qy && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:canonical-chromium-builds/stage && \
    apt-get install -qy \
        apt-transport-https \
        ca-certificates \
        chromium-browser \
        curl \
        firefox \
        gcc \
        git \
        inotify-tools \
        libffi-dev \
        libfontconfig1 \
        libnss3 \
        libnss3-tools \
        make \
        ruby-full \
        wget \
        xvfb \
        zlib1g-dev && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/* && \
    ln -s /usr/bin/chromium-browser /usr/bin/google-chrome

RUN gem install --no-ri --no-rdoc \
        'colorize' \
        'faraday' \
        'headless' \
        'rake' \
        'rspec' \
        'rubocop' \
        'watir' \
        'watir-rspec' \
        'watir-scroll' \
        'webdriver-highlighter' \
        'webdrivers'

## emundo User
RUN addgroup --gid 1101 rancher && \
    # Für RancherOS brauchen wir diese Gruppe: http://rancher.com/docs/os/v1.1/en/system-services/custom-system-services/#creating-your-own-console
    addgroup --gid 999 aws && \
    # Für die AWS brauchen wir diese Gruppe
    useradd -ms /bin/bash emundo && \
    adduser emundo sudo && \
    # Das ist notwendig, damit das Image in RancherOS funktioniert
    usermod -aG 999 emundo && \
    # Das ist notwendig, damit das Image in RancherOS funktioniert
    usermod -aG 1101 emundo && \
    # Das ist notwendig, damit das Image lokal funktioniert
    usermod -aG root emundo

USER emundo
WORKDIR /home/emundo
