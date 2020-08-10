#!/bin/bash

echo "Content-type: text/html;charset=UTF-8"
echo

### HTML GET id & gid ###

SHELLGET_STRING_GROUPID=$(shell_get_value "groupid")
SHELLGET_STRING_IDS=$(shell_get_value "ids")


if [ -z "$SHELLGET_STRING_IDS" ]
then
 exit
fi

if [ -z "$SHELLGET_STRING_GROUPID" ]
then
 SHELLGET_STRING_GROUPID=0
else
 if ! check_value_positiveinteger "$SHELLGET_STRING_IDS"
 then
  exit
 fi
fi

if [ -z "${CONFIG_MAPIMAGE_WFSLAYER[$SHELLGET_STRING_GROUPID]}" ]
then
 exit
fi

if [ "$(check_value_integersstring "$SHELLGET_STRING_IDS")" = false ]
then
 exit
fi

GLOBAL_STRING_BBOX=$(request_sql_bboxbyids "$SHELLGET_STRING_GROUPID" "$SHELLGET_STRING_IDS")

if [ -z "$GLOBAL_STRING_BBOX" ]
then
 exit
fi

GLOBAL_ARRAY_BBOX=( $GLOBAL_STRING_BBOX )

echo -n "$(convert_real_integer "${GLOBAL_ARRAY_BBOX[0]}" "$CONFIG_WMS_COORDINATEDECIMAL")"
echo -n ",$(convert_real_integer "${GLOBAL_ARRAY_BBOX[1]}" "$CONFIG_WMS_COORDINATEDECIMAL")"
echo -n ",$(convert_real_integer "${GLOBAL_ARRAY_BBOX[2]}" "$CONFIG_WMS_COORDINATEDECIMAL")"
echo -n ",$(convert_real_integer "${GLOBAL_ARRAY_BBOX[3]}" "$CONFIG_WMS_COORDINATEDECIMAL")"
