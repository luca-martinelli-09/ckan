#!/bin/bash

# Add organization
add_organization () {
  until $(curl --output /dev/null --silent --head --fail "${CKAN_SITE_URL}"); do
    echo "CKAN is not ready, yet. Trying again in two seconds."
    sleep 2
  done

  CKAN_SITE_URL=${CKAN_SITE_URL%/}
  API_KEY=$(psql ${CKAN_SQLALCHEMY_URL} -t -c "select apikey from public.user where name='${CKAN_SITE_ID}';")

  ORGANIZATION_DATA=$(jo name="${CKAN_SITE_ID}" email="${CKAN_ORG_EMAIL}" identifier="${CKAN_ORG_VAT}" title="${CKAN__SITE_TITLE}" description="Dataset inseriti dal personale per conto del ${CKAN__SITE_TITLE}." users="$(jo -p -a $(jo name="${CKAN_SITE_ID}") $(jo name="${CKAN_SYSADMIN_NAME}"))")

  curl -i -H "X-CKAN-API-Key: ${API_KEY}" -XPOST -d "${ORGANIZATION_DATA}" "${CKAN_SITE_URL}"/api/3/action/organization_create
}

add_organization

# Add groups
add_groups () {
  until $(curl --output /dev/null --silent --head --fail "${CKAN_SITE_URL}"); do
    echo "CKAN is not ready, yet. Trying again in two seconds."
    sleep 2
  done

  API_KEY=$(psql ${CKAN_SQLALCHEMY_URL} -t -c "select apikey from public.user where name='${CKAN_SITE_ID}';")

  for GROUP_FILE in /tmp/ckan-groups/*.json; do
    echo "Creating group from file ${GROUP_FILE}"

    GROUP_NAME=$(jq -r .name ${GROUP_FILE})
    GROUP_TITLE=$(jq -r .title ${GROUP_FILE})
    GROUP_DESCRIPTION=$(jq -r .description ${GROUP_FILE})
    CKAN_SITE_URL=${CKAN_SITE_URL%/}
    GROUP_IMAGE_URL=${CKAN_SITE_URL}$(jq -r .image_url ${GROUP_FILE})

    GROUP_DATA=$(jo name="${GROUP_NAME}" title="${GROUP_TITLE}" description="${GROUP_DESCRIPTION}" image_url="${GROUP_IMAGE_URL}")

    curl -i -H "X-CKAN-API-Key: ${API_KEY}" -XPOST -d "${GROUP_DATA}" "${CKAN_SITE_URL}"/api/3/action/group_create
  done
}

add_groups

exec "$@"