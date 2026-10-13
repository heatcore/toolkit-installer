#!/bin/sh

export PATH=$PATH:/snap/bin

systemctl stop edge-heatcore-nuc-py.service
systemctl disable edge-heatcore-nuc-py.service

# docker rmi 713613010142.dkr.ecr.ap-southeast-1.amazonaws.com/edge-heatcore-nuc:latest

# rm -f /etc/systemd/system/edge-heatcore-nuc-py.service
# rm -rf /etc/heatcore/ehn-py
