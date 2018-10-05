#!/bin/bash

SHELL_GET_CENTERX=$(shell_get_value "centerx")
SHELL_GET_CENTERY=$(shell_get_value "centery")
SHELL_GET_ZOOMLEVEL=$(shell_get_value "zoomlevel")
SHELL_GET_X=$(shell_get_value "x")
SHELL_GET_Y=$(shell_get_value "y")

SHELL_GET_CENTERX=$(check_value_integer "$SHELL_GET_CENTERX" "$CONFIG_WMS_MINX" "$CONFIG_WMS_MAXX" "$CONFIG_WMS_DEFAULTCENTERX")
SHELL_GET_CENTERY=$(check_value_integer "$SHELL_GET_CENTERY" "$CONFIG_WMS_MINY" "$CONFIG_WMS_MAXY" "$CONFIG_WMS_DEFAULTCENTERY")
SHELL_GET_ZOOMLEVEL=$(check_value_integer "$SHELL_GET_ZOOMLEVEL" "$CONFIG_WMS_ZOOMLEVEL_MIN" "$CONFIG_WMS_ZOOMLEVEL_MAX" "$CONFIG_WMS_ZOOMLEVEL_DEFAULT")
#SHELL_GET_X=$(check_value_integer "$SHELL_GET_X" "0" "$CONFIG_WMS_MAPIMAGE_WIDTH" "0")
#SHELL_GET_Y=$(check_value_integer "$SHELL_GET_Y" "0" "$CONFIG_WMS_MAPIMAGE_HEIGHT" "0")

LOCAL_BBOX=$(calculate_bbox "$SHELL_GET_ZOOMLEVEL" "$SHELL_GET_CENTERX" "$SHELL_GET_CENTERY")
LOCAL_WMS_INFO=$(download_info_wms "$LOCAL_BBOX" "$SHELL_GET_X" "$SHELL_GET_Y")
LOCAL_MAPTIP_VARIABLE=$(echo "$LOCAL_WMS_INFO" | /bin/sed -n -e "/^<TR><TH>maptip<\/TH><TD>/,/^<\/TD><\/TR>$/{s/^<TR><TH>maptip<\/TH><TD>//g;/^<\/TD><\/TR>$/d;p}")

IFS=' '
echo "$LOCAL_MAPTIP_VARIABLE"
