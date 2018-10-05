#!/bin/bash

if [ ! -z "$CONFIG_MAPIMAGE_WIDTH" ]
then
 SHELL_GET_MAPIMAGEWIDTH=$(shell_get_value "mapimagewidth")
fi

SHELL_GET_CENTERX=$(shell_get_value "centerx")
SHELL_GET_CENTERY=$(shell_get_value "centery")
SHELL_GET_ZOOMLEVEL=$(shell_get_value "zoomlevel")

SHELL_GET_CENTERX=$(check_value_integerbetweendefault "$SHELL_GET_CENTERX" "$CONFIG_WMS_MINX" "$CONFIG_WMS_MAXX" "$CONFIG_WMS_DEFAULTCENTERX")
SHELL_GET_CENTERY=$(check_value_integerbetweendefault "$SHELL_GET_CENTERY" "$CONFIG_WMS_MINY" "$CONFIG_WMS_MAXY" "$CONFIG_WMS_DEFAULTCENTERY")
SHELL_GET_ZOOMLEVEL=$(check_value_integerbetweendefault "$SHELL_GET_ZOOMLEVEL" "$CONFIG_WMS_ZOOMLEVELMIN" "$CONFIG_WMS_ZOOMLEVELMAX" "$CONFIG_WMS_ZOOMLEVELDEFAULT")

LOCAL_BBOX=$(calculate_bbox "$SHELL_GET_ZOOMLEVEL" "$SHELL_GET_CENTERX" "$SHELL_GET_CENTERY")

download_image_wms "$LOCAL_BBOX"
