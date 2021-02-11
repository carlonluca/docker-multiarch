FROM ubuntu:groovy

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y binfmt-support qemu-user-static docker.io jq
RUN apt-get clean
RUN mkdir -p ~/.docker/cli-plugins
RUN \
   if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
      CURR_ARCH="arm64"; \
   elif [ "$(dpkg --print-architecture)" = "armhf" ]; then \
      CURR_ARCH="arm-v7"; \
   elif [ "$(dpkg --print-architecture)" = "amd64" ]; then \
      CURR_ARCH="amd64"; \
   else exit 1; fi && \
   BUILDX_URL=$(curl https://api.github.com/repos/docker/buildx/releases/latest | jq -r .assets[].browser_download_url | grep $CURR_ARCH | grep linux) && \
   curl -L "$BUILDX_URL" -o ~/.docker/cli-plugins/docker-buildx
RUN chmod +x /root/.docker/cli-plugins/docker-buildx
