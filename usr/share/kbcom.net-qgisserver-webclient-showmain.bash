#!/bin/bash

echo "<style>
$CONFIG_SEARCH_STYLE
iframe.hidden { position: absolute; display: none; visibility: hidden; width: 0; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
</style>"

echo "<div id='container' style='position: absolute; top: 0; bottom: 0; left: 0; right: 0; margin: 0; padding: 0; border: 0; text-align: center;'>"

let "GLOBAL_WMS_MAPIMAGECONTAINER_WIDTH=$CONFIG_WMS_MAPIMAGE_WIDTH + 150"
let "GLOBAL_WMS_MAPIMAGECONTAINER_HEIGHT=$CONFIG_WMS_MAPIMAGE_HEIGHT + 10"

source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showpopups.bash"

echo "<table style='margin: auto; border: 0;'>"
echo "<tr>"
echo " <td style='border: 0;'>"
source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showsearch.bash"
echo " </td>"
echo "</tr>"
echo "<tr>"
echo " <td colspan='2' style='border: 0;'>"

echo "<iframe id='map' src='$GLOBAL_URL?type=showmap' style='height: ${GLOBAL_WMS_MAPIMAGECONTAINER_HEIGHT}px; width: ${GLOBAL_WMS_MAPIMAGECONTAINER_WIDTH}px; border: 0; margin: 0; padding: 0; border: 0;'>"
echo "</iframe>"

echo " </td>"
echo "</tr>"
echo "</table>"

echo "<iframe id='html' src='$GLOBAL_URL?type=showhtml' style='position: absolute; width: 100%; height: 0; left: 0; right: 0; border: 0;' onload='html_onload();'>"
echo "</iframe>"

echo "</div>"

if [ -z "$CONFIG_HTML_AUTOSIZE" ]
then
 echo "<script>
function html_onload()
{
 var map_rect=document.getElementById('map').getBoundingClientRect();

 document.getElementById('html').style.top=map_rect.bottom;
 document.getElementById('html').style.height=document.getElementById('html').contentWindow.document.body.scrollHeight;
}
</script>"
else
 echo "<script>
function html_onload()
{
 var map_rect=document.getElementById('map').getBoundingClientRect();
 var html_calculatedheight=document.getElementById('container').getBoundingClientRect().bottom - map_rect.bottom;

 document.getElementById('html').style.top=map_rect.bottom;

 if ( ${CONFIG_HTML_AUTOMINIMUMSIZE} < html_calculatedheight )
 {
  document.getElementById('html').style.height=html_calculatedheight;
 }
 else
 {
  document.getElementById('html').style.height=document.getElementById('html').contentWindow.document.body.scrollHeight;
 }
}
</script>"
fi
