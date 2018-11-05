#!/bin/bash

#echo "Content-type: text/html;charset=UTF-8"
#echo

SHELLGET_INTEGER_MAPIMAGEWIDTH=$(shell_get_value "mapimagewidth")
SHELLGET_INTEGER_LEFTX=$(shell_get_value "leftx")
SHELLGET_INTEGER_BOTTOMY=$(shell_get_value "bottomy")
SHELLGET_INTEGER_ZOOMLEVEL=$(shell_get_value "zoomlevel")
SHELLGET_INTEGER_X=$(shell_get_value "x")
SHELLGET_INTEGER_Y=$(shell_get_value "y")

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

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_X" "0" "$SHELLGET_INTEGER_MAPIMAGEWIDTH")" = false ]
then
 shell_exit
fi

if [ "$(check_value_integerbetween "$SHELLGET_INTEGER_Y" "0" "$CONFIG_WMS_IMAGEHEIGHT")" = false ]
then
 shell_exit
fi


echo "Content-type: text/html;charset=UTF-8"
echo

GLOBAL_BBOX_MAPIMAGE=$(calculate_bbox "$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$SHELLGET_INTEGER_ZOOMLEVEL" "$SHELLGET_INTEGER_LEFTX" "$SHELLGET_INTEGER_BOTTOMY")
GLOBAL_STRING_FEATUREINFO=$(request_featureinfo_wms "$SHELLGET_INTEGER_MAPIMAGEWIDTH" "$GLOBAL_BBOX_MAPIMAGE" "$SHELLGET_INTEGER_X" "$SHELLGET_INTEGER_Y")
GLOBAL_STRING_MAPTIP=$(echo -n "$GLOBAL_STRING_FEATUREINFO" | /bin/sed -n -e "/^<TR><TH>maptip<\/TH><TD>/,/^<\/TD><\/TR>$/{s/^<TR><TH>maptip<\/TH><TD>//g;/^<\/TD><\/TR>$/d;p}")

if [ -z "$GLOBAL_STRING_MAPTIP" ]
then
 exit
fi

### MAIN head & style classes ###

echo "
<!-- MAIN head & style classes -->
<html>
<head>
<title>$CONFIG_MAIN_TITLE - MAPTIP</title>
<style>
$CONFIG_MAPTIP_CSS
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1' style='margin: 0;'>
"

echo "$GLOBAL_STRING_MAPTIP"

echo "
</body>
</html>"
