#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-wmsclient.bash"

source $CONFIG_FOLDER_MAIN/etc/kbcom.net-qgisserver-wmsclient-html.conf
source $CONFIG_FOLDER_MAIN/etc/kbcom.net-qgisserver-wmsclient.conf


GLOBAL_URL=$(shell_url)
SHELL_GET_TYPE=$(shell_get_value type)

case "$SHELL_GET_TYPE" in
searchresult)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-wmsclient-showsearchresult.bash"
 show_footer_html
 ;;
wmsimage)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-wmsclient-showmapimg.bash"
 ;;
wmsmaptip)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-wmsclient-showmaptip.bash"
 show_footer_html
 ;;
showmap)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-wmsclient-showmap.bash"
 show_footer_html
 ;;
showhtml)
 show_header_html "
<meta http-equiv="refresh" content="${CONFIG_HTML_REFRESHINTERVAL}">
<style>
${CONFIG_HTML_STYLE}
</style>"
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-wmsclient-showhtml.bash"
 show_footer_html
 ;;
*)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-wmsclient-showmain.bash"
 show_footer_html
esac
