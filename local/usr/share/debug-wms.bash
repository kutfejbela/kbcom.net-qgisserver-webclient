#!/bin/bash

GLOBAL_SOCKET_QGISSERVER="/run/qgis_mapserv.sock"
GLOBAL_FILE_QGISPROJECT=""

GLOBAL_STRING_LAYER=""
GLOBAL_STRING_PROPERTY=""
GLOBAL_STRING_VALUE=""

# GetCapabilities
export QUERY_STRING="request=GetCapabilities&service=WMS&version=1.3.0&map=$GLOBAL_FILE_QGISPROJECT"

# GetFeatureInfo

# GetMap
#QUERY_STRING="request=GetFeature&service=WFS&version=2.0.0&map=$GLOBAL_FILE_QGISPROJECT"
#QUERY_STRING="$QUERY_STRING&outputFormat=GeoJSON&maxFeatures=16"
#QUERY_STRING="$QUERY_STRING&typename=$GLOBAL_STRING_LAYER"
#QUERY_STRING="$QUERY_STRING&Filter=<Filter>"
#QUERY_STRING="$QUERY_STRING <PropertyIsLike escapeChar='!' wildCard='*' singleChar='#' matchCase='false'>"
#QUERY_STRING="$QUERY_STRING  <PropertyName>$GLOBAL_STRING_PROPERTY</PropertyName>"
#QUERY_STRING="$QUERY_STRING  <Literal>*$GLOBAL_STRING_VALUE*</Literal>"
#QUERY_STRING="$QUERY_STRING </PropertyIsLike>"
#QUERY_STRING="$QUERY_STRING</Filter>"
#export QUERY_STRING

/usr/bin/cgi-fcgi -bind -connect $GLOBAL_SOCKET_QGISSERVER > debug-wms.txt
