#!/bin/sh

export PATH=$PATH:/snap/bin

tag=${1:-"latest"}

mkdir -p /etc/heatcore/ehn-py/
curl -o /etc/systemd/system/edge-heatcore-nuc-py.service https://github.com/heatcore/toolkit-installer/blob/main/edge-heatcore-nuc-py.service
sed -i "s/latest/$tag/g" /etc/systemd/system/edge-heatcore-nuc-py.service

docker pull 713613010142.dkr.ecr.ap-southeast-1.amazonaws.com/edge-heatcore-nuc:$tag
if [ $? -ne 0 ]; then
    echo "docker pull edge-nuc failed!"
    exit 1
fi

systemctl daemon-reload
systemctl disable edge-heatcore-nuc-py.service
systemctl enable edge-heatcore-nuc-py.service
systemctl stop edge-heatcore-nuc-py.service
systemctl start edge-heatcore-nuc-py.service
systemctl status edge-heatcore-nuc-py.service

docker rmi -f $(docker images -q -a -f dangling=true)
