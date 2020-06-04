#!/usr/bin/env bash
efs_id="$1"
EC2_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)
mount_dns="${efs_id}.efs.$EC2_REGION.amazonaws.com".
mount_ip=$(dig +short $mount_dns)
count=0
while [ "$mount_ip" = "" ]
do
  count=$((count + 1))
  echo "attempt number $count for mount unresolved, sleeping 10"
  sleep 2
  mount_ip=$(dig +short $mount_dns)
  if [ $count -gt 150 ] ; then echo "timeout waiting for efs - 5 min" ; break ; fi
done
