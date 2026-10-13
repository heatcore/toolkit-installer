#!/bin/sh

export PATH=$PATH:/snap/bin

tag=${1:-"latest"}

mkdir -p /etc/heatcore/ehn/logs
mkdir -p /etc/heatcore/ehn/profile
curl -o /etc/systemd/system/edge-heatcore-nuc.service https://github.com/heatcore/toolkit-installer/blob/main/edge-heatcore-nuc.service
sed -i "s/latest/$tag/g" /etc/systemd/system/edge-heatcore-nuc.service

docker pull 713613010142.dkr.ecr.ap-southeast-1.amazonaws.com/heatcore-nuc:$tag
if [ $? -ne 0 ]; then
    echo "docker pull nuc failed!"
    exit 1
fi

systemctl daemon-reload
systemctl disable edge-heatcore-nuc.service
systemctl enable edge-heatcore-nuc.service
systemctl stop edge-heatcore-nuc.service
systemctl start edge-heatcore-nuc.service
systemctl status edge-heatcore-nuc.service

docker rmi -f $(docker images -q -a -f dangling=true)
