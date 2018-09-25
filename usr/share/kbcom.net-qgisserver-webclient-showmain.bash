#!/bin/bash

echo "<style>
 div.container { position: absolute; top: 0; bottom: 0; left: 0; right: 0; margin: 0; padding: 0; border: 0; }
</style>"

echo "<div id='div_container' class='container'>"

source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showiframepopups.bash"
source "$GLOBAL_FOLDER_SCRIPT/kbcom.net-qgisserver-webclient-showiframefix.bash"

echo "</div>"
