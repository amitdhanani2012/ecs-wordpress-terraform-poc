FROM bitnami/wordpress
USER root
RUN apt-get update && apt-get -y install  curl
ENV AMIT_S3_BUCKET "s3-upload-test-amit"
ENV AMIT_S3_REGION "us-west-2"
COPY ./download-extra.sh /. 
COPY ./entrypoint.sh /opt/bitnami/scripts/wordpress/entrypoint.sh
RUN chmod 755 /download-extra.sh
RUN chmod 755 /opt/bitnami/scripts/wordpress/entrypoint.sh
RUN chown root.root /download-extra.sh
RUN chown root.root /opt/bitnami/scripts/wordpress/entrypoint.sh
HEALTHCHECK  --interval=300s --timeout=60s --retries=5 --start-period=300s \
   CMD curl --fail http://localhost:8080 || exit 1 
USER 1001
 
