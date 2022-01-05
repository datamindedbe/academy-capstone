FROM gitpod/workspace-full

ENV DEBIAN_FRONTEND=noninteractive
USER root

RUN apt update
RUN apt install -y unzip
RUN apt install -y openjdk-8-jdk
RUN apt install -y python3-venv

ENV VIRTUAL_ENV=/academy_venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
RUN pip install pyspark

RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install &&\
    rm -rf ./aws awscliv2.zip
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 3000
EXPOSE 8080