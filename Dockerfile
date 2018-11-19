FROM ubuntu:16.04

RUN apt-get update -qqy && apt-get install -y curl xvfb chromium-browser firefox

RUN ln -s /usr/bin/chromium-browser /usr/bin/google-chrome

RUN apt-get update -qqy \
  && apt-get -qqy install libnss3 libnss3-tools libfontconfig1 wget ca-certificates apt-transport-https inotify-tools \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*


RUN apt-get update -qqy && apt-get -y install ruby-full zlib1g-dev libffi-dev gcc make git

RUN apt-get autoclean

RUN gem install 'watir' --no-ri --no-rdoc
RUN gem install 'headless' --no-ri --no-rdoc
RUN gem install 'webdrivers' --no-ri --no-rdoc
RUN gem install 'watir-scroll' --no-ri --no-rdoc
RUN gem install 'rspec' --no-ri --no-rdoc
RUN gem install 'watir-rspec' --no-ri --no-rdoc
RUN gem install 'webdriver-highlighter' --no-ri --no-rdoc

ENV HEADLESS true

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
