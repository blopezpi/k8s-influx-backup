FROM influxdb:1.8

RUN apt-get update && \
    apt-get install awscli -y --no-install-recommends && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY backup-influxdb.sh .

ENV INFLUX_HOSTNAME="" \
    INFLUX_PORT="" \
    BUCKET_URI="" \
    AWS_ACCESS_KEY_ID="" \
    AWS_SECRET_ACCESS_KEY="" \
    AWS_DEFAULT_REGION="" \
    S3_ENDPOINT_URL="" 

CMD ["bash", "./backup-influxdb.sh"]
