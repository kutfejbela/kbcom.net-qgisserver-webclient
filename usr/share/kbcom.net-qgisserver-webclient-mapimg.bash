#!/bin/bash

#echo "Content-type: text/html;charset=UTF-8"
#echo

SHELLGET_INTEGER_MAPIMAGEWIDTH=$(shell_get_value "mapimagewidth")
SHELLGET_INTEGER_LEFTX=$(shell_get_value "leftx")
SHELLGET_INTEGER_BOTTOMY=$(shell_get_value "bottomy")
SHELLGET_INTEGER_ZOOMLEVEL=$(shell_get_value "zoomlevel")

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_MAPIMAGEWIDTH" "0" "$CONFIG_WMS_IMAGEFULLWIDTH")" = false ]
then
 shell_exit
fi

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_ZOOMLEVEL" "$CONFIG_WMS_ZOOMLEVELMINIMUM" "$CONFIG_WMS_ZOOMLEVELMAXIMUM")" = false ]
then
 shell_exit
fi

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_LEFTX" "$CONFIG_WMS_MINIMUMX" "$CONFIG_WMS_MAXIMUMX")" = false ]
then
 shell_exit
fi

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_BOTTOMY" "$CONFIG_WMS_MINIMUMY" "$CONFIG_WMS_MAXIMUMY")" = false ]
then
 shell_exit
fi

#echo "---$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$SHELLGET_INTEGER_ZOOMLEVEL" "$SHELLGET_INTEGER_LEFTX" "$SHELLGET_INTEGER_BOTTOMY---"
GLOBAL_BBOX_MAPIMAGE=$(convert_widthzoomxy_bbox "$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$SHELLGET_INTEGER_ZOOMLEVEL" "$SHELLGET_INTEGER_LEFTX" "$SHELLGET_INTEGER_BOTTOMY")
#echo "===$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$GLOBAL_BBOX_MAPIMAGE==="

request_image_wms "$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$GLOBAL_BBOX_MAPIMAGE"
