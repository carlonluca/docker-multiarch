FROM ubuntu:focal

RUN apt-get update
RUN apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install -y binfmt-support qemu-user-static docker.io jq
RUN apt-get clean
RUN mkdir -p ~/.docker/cli-plugins
RUN BUILDX_URL=$(curl https://api.github.com/repos/docker/buildx/releases/latest | jq -r .assets[].browser_download_url | grep $(dpkg --print-architecture) | grep linux) && \
   wget "$BUILDX_URL" -O ~/.docker/cli-plugins/docker-buildx
RUN chmod +x /root/.docker/cli-plugins/docker-buildx
