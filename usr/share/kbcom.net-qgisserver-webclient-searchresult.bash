#!/bin/bash

### SEARCHRESULT head & style classes ###

echo "
<!-- SEARCHRESULT head & style classes -->
<html>
<head>
<title>$CONFIG_MAIN_TITLE - Searchresult</title>
<style>
$CONFIG_SEARCHRESULT_CSS
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1'>
"

### GET searchtext ###

SHELL_GET_SEARCHTEXT=$(shell_get_value "searchtext")

# WFS search cannot sort and cannot handle non-ascii characters
GLOBAL_DBSTRING_SEARCHRESULT=$(download_wfs_searchresult "$SHELL_GET_SEARCHTEXT" | sort )
GLOBAL_STRING_SERCHRESULTHTML=""

if [ -z "$GLOBAL_DBSTRING_SEARCHRESULT" ]
then
 GLOBAL_STRING_HTMLOUTPUT="<p class='searchresult-message'>$CONFIG_SEARCHRESULT_NONETEXT</p>"
else
 GLOBAL_CONUTER_SEARCHRESULTITEM=0

 IFS=$'\n'
 for GLOBAL_ROWSTRING_SEARCHRESULT in $GLOBAL_DBSTRING_SEARCHRESULT
 do
  ((GLOBAL_COUNTER_SEARCHRESULTITEM++))

  if [ $GLOBAL_COUNTER_SEARCHRESULTITEM -gt $CONFIG_SEARCHRESULT_MAXIMUMITEMS ]
  then
   GLOBAL_STRING_HTMLOUTPUT="
<p class='searchresult-message'>$CONFIG_SEARCHRESULT_MORETHANMAXIMUMITEMSTEXT</p>
$GLOBAL_STRING_HTMLOUTPUT
<p class='searchresult-message'>$CONFIG_SEARCHRESULT_MORETHANMAXIMUMITEMSTEXT</p>"
   break
  fi

  IFS=$'\t'
  GLOBAL_ARRAY_SEARCHRESULT=($GLOBAL_ROWSTRING_SEARCHRESULT)
  IFS=$'\n'

  GLOBAL_STRING_HTMLOUTPUT+="
<p class='searchresult-item'
 onclick='parent.document.getElementById(\"map\").src=\"$GLOBAL_URL?type=showmap&id=${GLOBAL_ARRAY_SEARCHRESULT[1]}\";
 parent.document.getElementById(\"search_result\").style.visible=\"hidden\";'>"
  GLOBAL_STRING_HTMLOUTPUT+=$(convert_escapedstring_html "${GLOBAL_ARRAY_SEARCHRESULT[0]/\\\//\/}")
  GLOBAL_STRING_HTMLOUTPUT+="</p>"
 done
fi

echo "$GLOBAL_STRING_HTMLOUTPUT"

echo "
</body>
</html>"
