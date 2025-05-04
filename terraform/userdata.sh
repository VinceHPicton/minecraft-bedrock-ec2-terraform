#!/bin/bash
aws s3 cp s3://mc-bedrock-backup/worlds /home/ubuntu/worlds --recursive
export LD_LIBRARY_PATH=.
/home/ubuntu/start_server.sh
EOF