#!/bin/bash
cd /home/ubuntu
aws s3 cp s3://mc-bedrock-backup/worlds.zip /home/ubuntu/worlds.zip
unzip ./worlds.zip
rm ./worlds.zip
aws s3 cp s3://mc-bedrock-backup/server.properties /home/ubuntu/
aws s3 cp s3://mc-bedrock-backup/permissions.json /home/ubuntu/
export LD_LIBRARY_PATH=.
/home/ubuntu/start_server.sh
EOF