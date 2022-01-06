FROM public.ecr.aws/dataminded/spark-k8s-glue:v3.1.2-hadoop-3.3.1

ENV PYSPARK_PYTHON python3
WORKDIR /opt/spark/work-dir
USER 0

COPY src src
COPY scripts scripts
COPY setup.py .
RUN pip3 install -e .

