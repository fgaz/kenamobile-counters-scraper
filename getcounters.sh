#!/usr/bin/env bash

set -e

PHONENUMBER="${1}"
PASSWORD="${2}"
cookie=$(curl -s \
           --cookie-jar - \
           --output /dev/null \
           -d "action=maya_interrogate&maya_action=ldapLogin&user=${PHONENUMBER}&userPassword=${PASSWORD}" \
           https://www.kenamobile.it/wp-admin/admin-ajax.php \
           | tail -n1)
phpsessid=$(echo "${cookie}" | awk '{ print $7 }')
json=$(curl -s \
         -b "PHPSESSID=${phpsessid}" \
         -d "action=maya_interrogate&maya_action=getUserPromoBags&msisdn=${PHONENUMBER}" \
         https://www.kenamobile.it/wp-admin/admin-ajax.php)
echo "${json}" | jq

