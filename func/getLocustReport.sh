#!/bin/bash

workdir=$1
JOB_NAME=$2
masterhost=$3

export info="$0: $PWD"
bash ${workdir}/comm/echoInfo.sh $workdir

# localhost=$(ip addr | grep -e "eth0" -e "ens33" | grep "inet" | awk -F " " '{print $2}' | awk -F / '{print $1}')
locustReportBaseHome=$(cat ${workdir}/ini/config.ini | grep "locustReportBaseHome" |  awk -F = '{print $2}')

year=$(date +%Y)
mday=$(date +%m%d)
sudo mkdir -vp ${locustReportBaseHome}/$JOB_NAME/$year/$mday/
reportDir=${locustReportBaseHome}/$JOB_NAME/$year/$mday/
echo "$reportDir"

which python3 &> /dev/null
if [ $? -eq 0 ];then
  pip3 install beautifulsoup4 lxml
  python3 ${workdir}/python/sendLocustReports.py $JOB_NAME $reportDir $masterhost
else
  pip install beautifulsoup4 lxml
  python ${workdir}/python/sendLocustReports.py $JOB_NAME $reportDir $masterhost
fi
