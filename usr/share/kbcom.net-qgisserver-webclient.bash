#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient-check.bash"
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient-convert.bash"
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient-request.bash"
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient-shell.bash"
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient-wfssql.bash"

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
mapimage)
# show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-mapimg.bash"
 ;;
maptip)
# show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-maptip.bash"
# show_footer_html
 ;;
mapbbox)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-mapbbox.bash"
 ;;
map)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-map.bash"
 ;;
html)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-html.bash"
 ;;
*)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-main.bash"
esac
