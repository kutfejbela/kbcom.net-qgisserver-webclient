#!/bin/bash

echo "Content-type: text/html;charset=UTF-8"
echo

### MAIN head & style classes ###

echo "
<!-- MAIN head & style classes -->
<html>
<head>
<meta http-equiv='X-UA-Compatible' content='IE=edge'></meta>
<title>$CONFIG_MAIN_TITLE</title>
<style>
div.maincontainer { position: absolute; top: 0; bottom: 0; left: 0; right: 0; margin: 0; padding: 0; border: 0; }
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1'>
"

echo "<div id='maincontainer' class='maincontainer'>"

source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showiframefixes.bash"
source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showiframepopups.bash"

echo "</div>"

echo "
</body>
</html>"
