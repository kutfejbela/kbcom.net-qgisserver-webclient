#!/bin/bash

request_image_wms()
{
 local PARAMETER_INTEGER_MAPIMAGEWIDTH="$1"
 local PARAMETER_BBOX="$2"

 local QUERY_STRING

 QUERY_STRING="request=GetMap&service=WMS&version=1.3.0"
 QUERY_STRING+="&map=$CONFIG_QGIS_PROJECTFILE"

 QUERY_STRING+="&layers=$CONFIG_MAPIMAGE_WMSLAYERS"

 QUERY_STRING+="&styles=$CONFIG_WMS_STYLES"
 QUERY_STRING+="&crs=$CONFIG_WMS_CRS"
 QUERY_STRING+="&time=$CONFIG_WMS_TIMEFORMAT"

 QUERY_STRING+="&bbox=$PARAMETER_BBOX"

 QUERY_STRING+="&transparent=$CONFIG_WMS_TRANSPARENT"
 QUERY_STRING+="&bgcolor=$CONFIG_WMS_BGCOLOR"
 QUERY_STRING+="&width=$PARAMETER_INTEGER_MAPIMAGEWIDTH"
 QUERY_STRING+="&height=$CONFIG_WMS_IMAGEHEIGHT"
 QUERY_STRING+="&format=$CONFIG_WMS_FORMAT"

 /usr/bin/cgi-fcgi -bind -connect $CONFIG_QGISSERVER_SOCKET
}

request_featureinfo_wms()
{
 local PARAMETER_INTEGER_MAPIMAGEWIDTH="$1"
 local PARAMETER_BBOX="$2"
 local PARAMETER_INTEGER_X="$3"
 local PARAMETER_INTEGER_Y="$4"

 local QUERY_STRING

 QUERY_STRING="request=GetFeatureInfo&service=WMS&version=1.3.0"
 QUERY_STRING+="&map=$CONFIG_QGIS_PROJECTFILE"

 QUERY_STRING+="&info_format=text/html"
 QUERY_STRING+="&layers=$CONFIG_MAPTIP_WMSLAYERS"
 QUERY_STRING+="&query_layers=$CONFIG_MAPTIP_WMSLAYERS"

 QUERY_STRING+="&styles=$CONFIG_WMS_STYLES"
 QUERY_STRING+="&crs=$CONFIG_WMS_CRS"

 QUERY_STRING+="&bbox=$PARAMETER_BBOX"

 QUERY_STRING+="&width=$PARAMETER_INTEGER_MAPIMAGEWIDTH"
 QUERY_STRING+="&height=$CONFIG_WMS_IMAGEHEIGHT"
 QUERY_STRING+="&i=$PARAMETER_INTEGER_X"
 QUERY_STRING+="&j=$PARAMETER_INTEGER_Y"

 /usr/bin/cgi-fcgi -bind -connect $CONFIG_QGISSERVER_SOCKET
}