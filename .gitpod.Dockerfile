FROM gitpod/workspace-full

ENV DEBIAN_FRONTEND=noninteractive
ENV SPARK_LOCAL_IP=127.0.0.1

USER root
# Install apt packages and clean up cached files
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk python3-venv net-tools netcat socat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# Install the AWS CLI and clean up tmp files
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O ./awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws awscliv2.zip

USER gitpod
RUN echo "{ [ -f /workspace/gitpodissue/venv/bin/activate ] && source /workspace/gitpodissue/venv/bin/activate ;} || :" >> /home/gitpod/.bashrc

EXPOSE 3000
EXPOSE 8080
EXPOSE 4040