#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient.bash"

source $CONFIG_FOLDER_MAIN/etc/kbcom.net-qgisserver-webclient.conf

GLOBAL_URL=$(shell_url)
SHELL_GET_MODULE=$(shell_get_value "module")

case "$SHELL_GET_MODULE" in
search)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-search.bash"
 ;;
searchresult)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-searchresult.bash"
 ;;
wmsimage)
# show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmapimg.bash"
 ;;
wmsmaptip)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmaptip.bash"
 show_footer_html
 ;;
map)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-map.bash"
 ;;
html)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-html.bash"
 ;;
*)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmain.bash"
 show_footer_html
esac
