#!/bin/bash

# Set permissions
chown -R ckan:ckan /var/lib/ckan

# Add the sysadmin user
ckan -c $CKAN_INI user add $CKAN_SYSADMIN_NAME password=$CKAN_SYSADMIN_PASSWORD email=$CKAN_SYSADMIN_EMAIL
ckan -c $CKAN_INI sysadmin add $CKAN_SYSADMIN_NAME

# Add groups
add_groups () {
  until $(curl --output /dev/null --silent --head --fail "${CKAN_SITE_URL}"); do
    echo "CKAN is not ready, yet. Trying again in two seconds."
    sleep 2
  done

  apikey=$(psql ${CKAN_SQLALCHEMY_URL} -c "select apikey from public.user where name='${CKAN_SYSADMIN_NAME}';")

  for file in /tmp/ckan-groups/*.json; do
    echo "Creating group from file ${file}"
    curl -i -H "X-CKAN-API-Key: ${apikey}" -XPOST -d @$file "${CKAN_SITE_URL}"/api/3/action/group_create
  done
}

add_groups