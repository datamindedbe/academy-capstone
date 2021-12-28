FROM gitpod/openvscode-server

USER root

RUN apt update && apt install python:3.9
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install &&\
    rm -rf ./aws awscliv2.zip

EXPOSE 3000