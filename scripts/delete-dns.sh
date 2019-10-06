#!/bin/bash

AWS_REGION=$1
AWS_DOMAIN=$2

mkdir -p tmp/
aws elb describe-load-balancers --region ${AWS_REGION} --query 'LoadBalancerDescriptions[].LoadBalancerName' --output text > tmp/elb.txt

while read line
do
    ELB_CHECK=`aws elb describe-tags --region us-east-1 --load-balancer-name ${line} | grep ${OWNER}-${ENV} | wc -l`
    if [ ${ELB_CHECK} -gt 0 ]; then
        aws elb delete-load-balancer --region ${AWS_REGION} --load-balancer-name ${line}
    fi
done <  tmp/elb.txt

ZONE_ID=`aws route53 list-hosted-zones-by-name --dns-name ${AWS_DOMAIN} | grep hostedzone | cut -d "/" -f3 | cut -d '"' -f1`
sed -i 's/CREATE/DELETE/g' tmp/stress-dns.json
sed -i 's/CREATE/DELETE/g' tmp/guestbook-dns.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://tmp/stress-dns.json
aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://tmp/guestbook-dns.json
