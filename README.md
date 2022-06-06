# CKAN for Italian P.A.

[CKAN](https://ckan.org/) is a powerful data management system that makes data accessible – by providing tools to streamline publishing, sharing, finding and using data. This project provides everything you need to run CKAN plus a set of extensions for supporting Italian open data in a set of Docker images.

Any Italian public institution that wants to publish its data in an open format should follow these guidelines: ["Linee Guida Nazionali per la Valorizzazione del Patrimonio Informativo Pubblico"](https://docs.italia.it/italia/daf/lg-patrimonio-pubblico/it/stabile/index.html). Technical details and best practices for data catalogues development and management are contained in these guidelines: ["Linee guida per i cataloghi dati"](https://docs.italia.it/italia/daf/linee-guida-cataloghi-dati-dcat-ap-it/it/stabile/). Open data published by Italian public institutions should be compliant to the [national metadata profile called DCAT-AP_IT](https://www.dati.gov.it/content/dcat-ap-it-v10-profilo-italiano-dcat-ap-0).

This project is an **unofficial** CKAN distribution packaged with plugins and external components that ensure the compliance with DCAT_AP-IT and all the official guidelines mentioned above. The **official** CKAN distribution is [CKAN-IT](https://github.com/italia/ckan-it), which is no more updated.

## Tools references
The tools used in this repository are
- [CKAN](https://ckan.org/)
- [Docker](https://www.docker.com/)

## Main components
- **CKAN** version 2.9 with the extensions listed at the end of this document.
- **Solr** version 8 packaged for CKAN and with some customizations.
- **PostgreSQL** version 12 with **PostGIS** version 3.2, modified for CKAN.
- **Redis** latest version.

## Plugins references
- [spatial](https://github.com/ckan/ckanext-spatial/)
- [harvest](https://github.com/ckan/ckanext-harvest/)
- [multilang](https://github.com/geosolutions-it/ckanext-multilang/)
- [dcat](https://github.com/ckan/ckanext-dcat/)
- [dcatapit](https://github.com/italia/ckanext-dcatapit/)

## Installation
### Step 1
Clone the following repository
    
    git clone https://github.com/luca-martinelli-09/ckan.git
    cd ckan

### Step 2
Rename `.env.template` file to `.env` and set the following parameters.

```ini
CKAN_SITE_URL # URL of the custom CKAN's portal

CKAN_SYSADMIN_NAME # Name of the sysadmin account
CKAN_SYSADMIN_PASSWORD # Password for the sysadmin account
CKAN_SYSADMIN_EMAIL # Email for the sysadmin account

CKAN_ORG_VAT # IPA/VAT/IVA of the organization
CKAN_ORG_EMAIL # Email of the organization

CKAN__DATAPUSHER__CALLBACK_URL_BASE # Same as CKAN_SITE_URL

# Email setup
CKAN_SMTP_SERVER
CKAN_SMTP_STARTTLS
CKAN_SMTP_USER
CKAN_SMTP_PASSWORD
CKAN_SMTP_MAIL_FROM

CKANEXT__DCAT__BASE_URI # Same as CKAN_SITE_URL

GEONAMES__USERNAME # Follow the guide for geosolutions-it/ckanext-dcatapit extension
```

### Step 3
Rename `ckan/Dockerfile.template` to `Dockerfile` and, if needed, add your commands. Then execute with Docker

    docker-compose build
    docker-compose up -d

Or

    docker compose build
    docker compose up -d

For Docker Compose v2.

## Troubleshooting
### First startup
At first startup CKAN probably can't configure all the plugins and initialize the databases. Try restarting the containers with

    docker compose restart

### Wrong username or password
Try entering in the CKAN shell executing

    docker exec -it ckan sh
  
And then execute

    ckan -c $CKAN_INI user add $CKAN_SYSADMIN_NAME  password=$CKAN_SYSADMIN_PASSWORD email=$CKAN_SYSADMIN_EMAIL
    ckan -c $CKAN_INI sysadmin add $CKAN_SYSADMIN_NAME

### Internal server error when adding an Organization
This can happens due to wrong permissions for the `/var/lib/ckan` folder. To solve this problem, first enter in the CKAN shell executing

    docker exec -it ckan sh

And then set the right permissions

    chown -R ckan:ckan /var/lib/ckan

## Plugins
- [envvars](https://github.com/okfn/ckanext-envvars)
- view
  - text_view
  - image_view
  - recline_view
- datastore
- datapusher
- [spatial](https://github.com/ckan/ckanext-spatial)
  - spatial_metadata
  - spatial_query
- [harvest](https://github.com/ckan/ckanext-harvest)
  - ckan_harvester
- [multilang](https://github.com/geosolutions-it/ckanext-multilang)
  - multilang_harvester
- [dcat](https://github.com/ckan/ckanext-dcat)
  - dcat_rdf_harvester
  - dcat_json_harvester
  - dcat_json_interface structured_data
- [dcatapit](https://github.com/italia/ckanext-dcatapit)
  - dcatapit_pkg
  - dcatapit_org
  - dcatapit_config
  - dcatapit_subcatalog_facets
  - dcatapit_theme_group_mapper
  - dcatapit_ckan_harvester
  - dcatapit_harvest_list
  - dcatapit_harvester
  - dcatapit_csw_harvester

## Extending CKAN
You can extend the CKAN image with other plugins. Follow the guide on the original repository [okfn/docker-ckan](https://github.com/okfn/docker-ckan).