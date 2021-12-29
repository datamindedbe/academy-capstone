FROM gitpod/openvscode-server

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y python3.7-dev
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN apt install -y unzip
RUN apt install -y python3-pip
RUN python -m pip install --upgrade pip
RUN apt install -y openjdk-8-jdk
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install &&\
    rm -rf ./aws awscliv2.zip
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 3000