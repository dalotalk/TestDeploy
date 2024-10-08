#!/bin/bash

targetDir=$1
cores=$2

# 多主机的统一执行入口
curdate="$(date +%Y%m%d)"
workdir=$(find $targetDir -type d -name "TestDeploy*" | head -1)

export info="$0: $PWD"
bash ${workdir}/comm/echoInfo.sh $workdir

locust_workspace=$(cat ${workdir}/ini/config.ini | grep "locust_workspace" | awk -F = '{print $2}')
JOB_NAME=$(cat ${workdir}/ini/remoteProject.ini | grep "projectPackage" | awk -F = '{print $2}')

echo "this is locustExe_masterToWorkers"
bash ${workdir}/views/installDocker.sh $workdir
bash ${workdir}/func/installDockerCompose.sh ${workdir}
cat ${workdir}/data/daemon.json > /etc/docker/daemon.json

bash ${workdir}/views/buildLocustImage.sh $workdir $JOB_NAME

echo "locustExe_mw cores are: $cores"
cd ${locust_workspace}/$JOB_NAME
/usr/local/bin/docker-compose -f docker-compose-worker.yml up --scale worker=$cores

