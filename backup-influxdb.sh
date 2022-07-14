#!/bin/bash

set -e

SCRIPT_NAME=$0
ARCHIVE_NAME=influxdb_$(date +%Y%m%d_%H%M%S).gz
HOST=${INFLUX_HOSTNAME:-localhost}
PORT=${INFLUX_PORT:-8088}
INFLUX_HOST="${HOST}:${PORT}"
BACKUP_PATH="/tmp/backup"


mkdir -p ${BACKUP_PATH}

echo "[$SCRIPT_NAME] Dumping influxdb to compressed archive..."

influxd backup -portable \
    -host "${INFLUX_HOST}" \
    ${BACKUP_PATH} && \
    tar -cf "${ARCHIVE_NAME}" -C "${BACKUP_PATH}" .


echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws s3 cp "${ARCHIVE_NAME}" "${BUCKET_URI}/${ARCHIVE_NAME}"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "${ARCHIVE_NAME}" || true

echo "[$SCRIPT_NAME] Backup complete!"
