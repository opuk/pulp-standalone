#!/bin/bash
pulp-admin rpm repo create --feed=$1 --repo-id $2 --serve-http=true
