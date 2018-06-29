#!/usr/bin/env bash

set -e

PHONENUMBER="${1}"
PASSWORD="${2}"

authenticate(){
  cookie="$(curl -s \
             --cookie-jar - \
             --output /dev/null \
             -d "action=maya_interrogate&maya_action=ldapLogin&user=${1}&userPassword=${2}" \
             https://www.kenamobile.it/wp-admin/admin-ajax.php \
             | tail -n1)"
  phpsessid="$(echo "${cookie}" | awk '{ print $7 }')"
  echo "${phpsessid}"
}

getcounters(){
  json="$(curl -s \
           -b "PHPSESSID=${2}" \
           -d "action=maya_interrogate&maya_action=getUserPromoBags&msisdn=${1}" \
           https://www.kenamobile.it/wp-admin/admin-ajax.php)"
  echo "${json}"
}

auth="$(authenticate ${PHONENUMBER} ${PASSWORD})"
echo "$(getcounters ${PHONENUMBER} ${auth})"

