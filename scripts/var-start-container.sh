#!/bin/bash

WORKSPACE_DIR="$(pwd)"

dpkg -l | grep "docker.io" > /dev/null

if [ $? -ne 0 ]; then
    echo "##################################################################################"
    echo "# [Error] Docker binary was not found in the system. Please, consider installing #"
    echo "# the docker.io package with the following command or equivalent:                #"
    echo "# 'sudo apt-get update && sudo apt install docker.io'                            #"
    echo "##################################################################################"
    exit 1
fi

systemctl status docker | grep 'Active:' | awk '{print $2}' | grep 'active' > /dev/null

if [ $? -ne 0 ]; then
    echo "############################################################################################"
    echo "# [Error] Docker service failed starting or it was not started. Please, consider verifying #"
    echo "# the service status or restart the service with the following commands or equivalents:    #"
    echo "# 'sudo systemctl status docker' or 'sudo systemctl restart docker'                        #"
    echo "############################################################################################"
    exit 1
fi

groups ${USER} | grep -q "docker"

if [ $? -ne 0 ]; then
    echo "################################################################"
    echo "# [Error] User has not enough rights to docker binary. Please, #"
    echo "# consider running the following command or equivalent:        #"
    echo "# 'sudo usermod -aG docker ${USER}'                            #"
    echo "################################################################"
    exit 1
fi

./sources/var-host-docker-containers/run.sh -u 22.04 -w "$WORKSPACE_DIR"

if [ $? -ne 0 ]; then
    echo "#################################################"
    echo "# [Error] Unable to start the docker container. #"
    echo "#################################################"
    exit 1
fi
