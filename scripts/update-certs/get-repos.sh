#!/bin/bash
pulp-admin rpm repo list | grep Id | awk '{ print $2 }'
