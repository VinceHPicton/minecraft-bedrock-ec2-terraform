#!/bin/bash
cd /home/ubuntu
screen -S bedrock -X stuff 'stop'`echo -ne '\015'`
zip -r worlds.zip worlds
aws s3 cp ./worlds.zip s3://mc-bedrock-backup/worlds.zip
./start_server.sh
