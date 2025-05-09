#!/bin/bash
cd /home/ubuntu
screen -S bedrock -X stuff 'stop'`echo -ne '\015'`
aws s3 cp ./worlds s3://mc-bedrock-backup/worlds --recursive
./start_server.sh
