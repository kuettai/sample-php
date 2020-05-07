#!/bin/bash
S3BUCKET='	kuettai-asglogdemo-test'
BACKUPDIRECTORY='/var/log'
ASGNAME='asgDemo'
HOOKRESULT='CONTINUE'
LIFECYCLEHOOKNAME='asgHookTERM'
INSTANCEID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
REGION=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
REGION=${REGION::-1}
tar -czf /tmp/${INSTANCEID}.tar.gz $BACKUPDIRECTORY &> /tmp/backup
aws s3 cp /tmp/${INSTANCEID}.tar.gz s3://${S3BUCKET}/${INSTANCEID}/ &> /tmp/backup
aws autoscaling complete-lifecycle-action --lifecycle-hook-name ${LIFECYCLEHOOKNAME} --auto-scaling-group-name ${ASGNAME} --lifecycle-action-result ${HOOKRESULT} --instance-id ${INSTANCEID}  --region ${REGION}
