#!/bin/bash

source ./functions.sh

cd /home/ubuntu
./stop_server.sh
zip -r worlds.zip worlds
aws s3 cp ./worlds.zip s3://mc-bedrock-backup/worlds.zip
./start_server.sh
