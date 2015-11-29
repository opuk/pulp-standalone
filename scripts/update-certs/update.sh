#!/bin/bash
for i in $(cat repos.list); do echo pulp-admin rpm repo update --repo-id $i --feed-cert=/root/employee.crt --feed-key=/root/employee.key; done
