#!/bin/bash

# Set permissions
chown -R ckan:ckan /var/lib/ckan

# Add the sysadmin user
ckan -c $CKAN_INI user add $CKAN_SYSADMIN_NAME password=$CKAN_SYSADMIN_PASSWORD email=$CKAN_SYSADMIN_EMAIL
ckan -c $CKAN_INI sysadmin add $CKAN_SYSADMIN_NAME

# Add organization
organization_data() {
  cat <<EOF
{
  "name": "${CKAN_SITE_ID}",
  "title": "${CKAN__SITE_TITLE}",
  "description": "Dataset inseriti dal personale per conto del '${CKAN__SITE_TITLE}.",
  "image_url": "${CKAN__SITE_LOGO}"
}
EOF
}

add_organization () {
  until $(curl --output /dev/null --silent --head --fail "${CKAN_SITE_URL}"); do
    echo "CKAN is not ready, yet. Trying again in two seconds."
    sleep 2
  done

  API_KEY=$(psql ${CKAN_SQLALCHEMY_URL} -t -c "select apikey from public.user where name='${CKAN_SITE_ID}';")

  curl -i -H "X-CKAN-API-Key: ${API_KEY}" -XPOST -d "$(organization_data)" "${CKAN_SITE_URL}"/api/3/action/organization_create
}

add_organization

# Add groups
add_groups () {
  until $(curl --output /dev/null --silent --head --fail "${CKAN_SITE_URL}"); do
    echo "CKAN is not ready, yet. Trying again in two seconds."
    sleep 2
  done

  API_KEY=$(psql ${CKAN_SQLALCHEMY_URL} -t -c "select apikey from public.user where name='${CKAN_SITE_ID}';")

  for file in /tmp/ckan-groups/*.json; do
    echo "Creating group from file ${file}"
    curl -i -H "X-CKAN-API-Key: ${API_KEY}" -XPOST -d @$file "${CKAN_SITE_URL}"/api/3/action/group_create
  done
}

add_groups