#!/bin/bash

# usage: ./deployme.sh staging sddffafaafaf
# license: public domain

application_name="Wishlist-app"
environment_name="Wishlistapp-env"

NAME=user-wishlist-app
EB_BUCKET=jenkins-docker-aws-eb

VERSION="main"
ZIP="ver2.zip"

aws configure set default.region ap-south-1

# Zip up the Dockerrun file (feel free to zip up an .ebextensions directory with it)
zip -r $ZIP Dockerrun.aws.json

aws s3 cp $ZIP s3://$EB_BUCKET/$ZIP

# Create a new application version with the zipped up Dockerrun file
aws elasticbeanstalk create-application-version --application-name $application_name \
    --version-label $VERSION --source-bundle S3Bucket=$EB_BUCKET,S3Key=$ZIP

# Update the environment to use the new application version
aws elasticbeanstalk update-environment --environment-name $environment_name \
      --version-label $VERSION