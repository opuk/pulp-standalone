#!/bin/bash
systemctl $1 mongod
systemctl $1 httpd
systemctl $1 pulp_celerybeat.service
systemctl $1 pulp_resource_manager.service
systemctl $1 pulp_workers.service
systemctl $1 qpidd

