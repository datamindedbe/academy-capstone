FROM gitpod/openvscode-server

USER root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update
RUN apt install -y python3.7 unzip python3-pip cmake python-dev libjemalloc-dev libboost-dev \
                       libboost-filesystem-dev \
                       libboost-system-dev \
                       libboost-regex-dev
RUN ln -s /usr/bin/pip3 /usr/bin/pip
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN pip install --upgrade pip
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install &&\
    rm -rf ./aws awscliv2.zip
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 3000