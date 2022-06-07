#!/bin/bash

# Set permissions
sudo chown -R ckan:ckan /var/lib/ckan

# Add the sysadmin user
ckan -c $CKAN_INI user add $CKAN_SYSADMIN_NAME password=$CKAN_SYSADMIN_PASSWORD email=$CKAN_SYSADMIN_EMAIL
ckan -c $CKAN_INI sysadmin add $CKAN_SYSADMIN_NAME

# Setup organizations and groups
chmod +x /tmp/ckan-groups/ckan_setup.sh
nohup /tmp/ckan-groups/ckan_setup.sh &> /tmp/ckan-groups/log &

exec "$@"