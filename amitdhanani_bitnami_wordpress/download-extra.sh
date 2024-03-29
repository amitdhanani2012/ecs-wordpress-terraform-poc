#!/bin/bash
set +o errexit
set +o nounset
set +o pipefail
set -x
export export AWS_CONTAINER_CREDENTIALS_FULL_URI=http://localhost/get-credentials
cd /opt/bitnami/wordpress/
echo '{ "require": { "humanmade/s3-uploads":"*" } }' >composer.json
composer config --no-plugins allow-plugins.composer/installers true
composer require humanmade/s3-uploads
sed -i "/<?php/a \
require_once __DIR__ . '/vendor/autoload.php';\\n\
define('WP_MEMORY_LIMIT', '256M');\\n\
define( 'S3_UPLOADS_BUCKET' , '$AMIT_S3_BUCKET/' );\\n\
define( 'S3_UPLOADS_REGION', '$AMIT_S3_REGION' );\\n\
define( 'S3_UPLOADS_USE_INSTANCE_PROFILE', true );\\n" /opt/bitnami/wordpress/wp-config.php
/opt/bitnami/wp-cli/bin/wp plugin is-active s3-uploads || /opt/bitnami/wp-cli/bin/wp plugin activate s3-uploads
/opt/bitnami/wp-cli/bin/wp s3-uploads verify
