#!/bin/bash
for i in $(cat repos.list); do pulp-admin rpm repo update --repo-id $i --feed-cert=/root/employee.crt --feed-key=/root/employee.key; done
