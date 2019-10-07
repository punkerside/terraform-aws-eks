#!/bin/bash

OWNER=$1
PROJECT=$2
ENV=$3
AWS_REGION=$4
AWS_DOMAIN=$5

mkdir -p tmp/
rm -rf tmp/dns.json && cp scripts/dns.json tmp/dns.json
aws elb describe-load-balancers --region ${AWS_REGION} --query 'LoadBalancerDescriptions[].LoadBalancerName' --output text > tmp/elb.txt

while read line
do
    ELB_CHECK=`aws elb describe-tags --region us-east-1 --load-balancer-name ${line} | grep ${OWNER}-${ENV} | wc -l`
    if [ ${ELB_CHECK} -gt 0 ]; then
        ELB_ID=`aws elb describe-load-balancers --region ${AWS_REGION} --load-balancer-name ${line} --query 'LoadBalancerDescriptions[].CanonicalHostedZoneNameID' --output text`
        ELB_DNS=`aws elb describe-load-balancers --region ${AWS_REGION} --load-balancer-name ${line} --query 'LoadBalancerDescriptions[].CanonicalHostedZoneName' --output text`
        ZONE_ID=`aws route53 list-hosted-zones-by-name --dns-name ${AWS_DOMAIN} | grep hostedzone | cut -d "/" -f3 | cut -d '"' -f1`
        sed -i 's/ELB_ID/'${ELB_ID}'/g' tmp/dns.json
        sed -i 's/ELB_DNS/'${ELB_DNS}'/g' tmp/dns.json
        sed -i 's/AWS_DOMAIN/'${AWS_DOMAIN}'/g' tmp/dns.json
        aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file://tmp/dns.json
    fi
done <  tmp/elb.txt
