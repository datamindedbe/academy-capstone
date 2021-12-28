FROM gitpod/openvscode-server

USER root

RUN apt update
RUN apt install software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.9 --no-cache-dir
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install &&\
    rm -rf ./aws awscliv2.zip

EXPOSE 3000