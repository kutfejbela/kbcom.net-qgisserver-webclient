#!/bin/bash

GLOBAL_FOLDER_SCRIPT=$(/usr/bin/dirname "$0")
source "$GLOBAL_FOLDER_SCRIPT/.kbcom.net-qgisserver-webclient.bash"

#source $CONFIG_FOLDER_MAIN/etc/kbcom.net-qgisserver-webclient-html.conf
source $CONFIG_FOLDER_MAIN/etc/kbcom.net-qgisserver-webclient.conf


GLOBAL_URL=$(shell_url)
SHELL_GET_TYPE=$(shell_get_value type)

case "$SHELL_GET_TYPE" in
showsearch)
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showsearch.bash"
 ;;
searchresult)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showsearchresult.bash"
 show_footer_html
 ;;
wmsimage)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmapimg.bash"
 show_footer_html
 ;;
wmsmaptip)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmaptip.bash"
 show_footer_html
 ;;
showmap)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmap.bash"
 show_footer_html
 ;;
showhtml)
 show_header_html "
<meta http-equiv="refresh" content="${CONFIG_HTML_REFRESHINTERVAL}">
<style>
${CONFIG_HTML_CSS}
</style>"
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showhtml.bash"
 show_footer_html
 ;;
*)
 show_header_html
 source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showmain.bash"
 show_footer_html
esac
