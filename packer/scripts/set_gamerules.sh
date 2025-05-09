#!/bin/bash

source ./functions.sh

cd /home/ubuntu
send_to_screen bedrock "gamerule doInsomnia false"
send_to_screen bedrock "gamerule mobGriefing false"
send_to_screen bedrock "gamerule doTraderSpawning false"
