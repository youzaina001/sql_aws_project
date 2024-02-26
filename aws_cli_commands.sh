#!/bin/bash

read -p "Choose a unique name for your aws s3 bucket: " filename

# create an s3 bucket
aws s3 mb s3://"$filename" --region eu-west-1

# copy data files into the aws s3 bucket
aws s3 cp data s3://"$filename" --recursive