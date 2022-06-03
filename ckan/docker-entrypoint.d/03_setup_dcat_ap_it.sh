#!/bin/bash

ckan --config=$CKAN_INI dcatapit initdb

ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/languages-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/data-theme-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/places-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/frequencies-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/filetypes-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/theme-subtheme-mapping.rdf --eurovoc ./ckanext-dcatapit/vocabularies/eurovoc-filtered.rdf
ckan -c $CKAN_INI dcatapit load --filename ./ckanext-dcatapit/vocabularies/licences.rdf

ckan --config=$CKAN_INI search-index rebuild