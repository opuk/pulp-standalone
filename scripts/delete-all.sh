#!/bin/bash
for i in $(pulp-admin rpm repo list | grep Id | awk '{ print $2 }'); do
pulp-admin rpm repo delete --repo-id=$i
done;
