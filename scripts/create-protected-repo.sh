#!/bin/bash
CERT=/root/employee.crt
KEY=/root/employee.key
pulp-admin rpm repo create --feed=$1 --repo-id $2 --feed-cert=$CERT --feed-key=$KEY --feed-ca-cert=/root/redhat-uep.pem --serve-http=true
