#!/bin/sh

export PATH=$PATH:/snap/bin

tag=${1:-"latest"}
pub_key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIArl20Sm1qmBFHetRIEj9jxbz3kxG4c+f53xkJrFLAlz"

mkdir -p /root/.ssh
if [ $(grep -rnw "$pub_key" /root/.ssh | wc -l) -eq 0 ]; then
    echo "$pub_key" >>/root/.ssh/authorized_keys
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
fi

mkdir -p /etc/heatcore/eht
curl -o /etc/systemd/system/edge-heatcore-toolkit.service https://github.com/heatcore/toolkit-installer/blob/main/edge-heatcore-toolkit.service
sed -i "s/latest/$tag/g" /etc/systemd/system/edge-heatcore-toolkit.service

docker pull 713613010142.dkr.ecr.ap-southeast-1.amazonaws.com/edge-heatcore-toolkit:$tag
if [ $? -ne 0 ]; then
    echo "docker pull toolkit failed!"
    exit 1
fi

systemctl daemon-reload
systemctl disable edge-heatcore-toolkit.service
systemctl enable edge-heatcore-toolkit.service
systemctl stop edge-heatcore-toolkit.service
systemctl start edge-heatcore-toolkit.service
systemctl status edge-heatcore-toolkit.service

docker rmi -f $(docker images -q -a -f dangling=true)
