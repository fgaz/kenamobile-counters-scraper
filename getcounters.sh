#!/usr/bin/env bash
PHONENUMBER="${1}"
PHPSESSID=""
curl -b "PHPSESSID=$PHPSESSID" \
     -d "action=maya_interrogate&maya_action=getUserPromoBags&msisdn=$PHONENUMBER" \
     https://www.kenamobile.it/wp-admin/admin-ajax.php | jq

