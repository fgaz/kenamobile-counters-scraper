#!/usr/bin/env bash

set -e

AJAXURL="https://www.kenamobile.it/wp-admin/admin-ajax.php"
declare -A OPERATIONS
OPERATIONS[get_promo_counters]="getUserPromoBags"
OPERATIONS[get_services]="getServices"
OPERATIONS[get_customer_info]="getCustomerByMsisdn"
OPERATIONS[get_credit_info]="getCreditInfo"
OPERATIONS[get_sim_info]="getInfoSimByMSISDN"
OPERATIONS[get_invoice]="getInvoiceProfile"
OPERATIONS[get_available_options]="getUserOptionsBags"


authenticate(){
  cookie="$(curl -s \
             --cookie-jar - \
             --output /dev/null \
             -d "action=maya_interrogate&maya_action=ldapLogin&user=${1}&userPassword=${2}" \
             ${AJAXURL} \
             | tail -n1)"
  phpsessid="$(echo "${cookie}" | awk '{ print $7 }')"
  echo "${phpsessid}"
}

make_ajax(){
  json="$(curl -s \
           -b "PHPSESSID=${2}" \
           -d "action=maya_interrogate&maya_action=${3}&msisdn=${1}" \
           ${AJAXURL})"
  echo "${json}"
}

execute_operation(){
  echo "$(make_ajax $1 $2 ${OPERATIONS["${3}"]})"
}

usage(){
  echo "USAGE:" >&2
  echo "  ${0} PHONENUMBER PASSWORD ACTION" >&2
  echo "  Where ACTION is one of: ${!OPERATIONS[@]}" >&2
}

PHONENUMBER="${1}"
PASSWORD="${2}"
OPERATION="${3}"

if [ -z "${3}" ]; then
  echo "Error. Not enough arguments." >&2
  usage
  exit 2
fi

if [ -z "${OPERATIONS[${3}]}" ]; then
  echo "Error. Unknown operation." >&2
  usage
  exit 2
fi

auth="$(authenticate ${PHONENUMBER} ${PASSWORD})"
echo "$(execute_operation ${PHONENUMBER} ${auth} ${OPERATION})"

