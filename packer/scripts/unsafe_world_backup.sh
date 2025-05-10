#!/bin/bash

# Backs up the world without stopping the server, can result in corrupted worlds

source ./functions.sh

cd /home/ubuntu
zip -r unsafe_worlds.zip worlds
aws s3 cp ./unsafe_worlds.zip s3://mc-bedrock-backup/unsafe_worlds.zip
