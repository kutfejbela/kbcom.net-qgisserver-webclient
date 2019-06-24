#!/bin/bash

echo "Content-type: text/html;charset=UTF-8"
echo

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

SHELLGET_STRING_SEARCHTEXT=$(shell_get_value "searchtext")

GLOBAL_DBSTRING_SEARCHRESULT=$(request_sql_searchresult "$SHELLGET_STRING_SEARCHTEXT")


GLOBAL_ROWSTRING_FIRSTSEARCHRESULT=""
GLOBAL_STRING_HTMLOUTPUT=""

if [ -z "$GLOBAL_DBSTRING_SEARCHRESULT" ]
then
 GLOBAL_STRING_HTMLOUTPUT="<p id='notice' tabindex='0' class='searchresult-message'>$CONFIG_SEARCHRESULT_NONETEXT</p>"
else
 GLOBAL_CONUTER_SEARCHRESULTITEM=0

 IFS=$'\n'
 for GLOBAL_ROWSTRING_SEARCHRESULT in $GLOBAL_DBSTRING_SEARCHRESULT
 do
  ((GLOBAL_COUNTER_SEARCHRESULTITEM++))

  if [ $GLOBAL_COUNTER_SEARCHRESULTITEM -eq 1 ]
  then
   GLOBAL_STRING_SEARCHRESULTID="first"
  else
   GLOBAL_STRING_SEARCHRESULTID="others"
  fi

  if [ $GLOBAL_COUNTER_SEARCHRESULTITEM -gt $CONFIG_SEARCHRESULT_MAXIMUMITEMS ]
  then
  GLOBAL_STRING_HTMLOUTPUT="
<p id='notice' tabindex='0' class='searchresult-message'
 onkeyup='if (event.which == 27) parent.document.getElementById(\"iframe_search\").contentWindow.document.getElementById(\"search_inputbox\").focus(); if (event.which == 40) this.nextElementSibling.focus();'>$CONFIG_SEARCHRESULT_MORETHANMAXIMUMITEMSTEXT</p>
$GLOBAL_STRING_HTMLOUTPUT
<p tabindex='0' class='searchresult-message'
 onkeyup='if (event.which == 27) parent.document.getElementById(\"iframe_search\").contentWindow.document.getElementById(\"search_inputbox\").focus(); if (event.which == 38) this.previousElementSibling.focus();''>$CONFIG_SEARCHRESULT_MORETHANMAXIMUMITEMSTEXT</p>"
   break
  fi

  IFS=$'\t'
  GLOBAL_ARRAY_SEARCHRESULT=($GLOBAL_ROWSTRING_SEARCHRESULT)
  IFS=$'\n'

  GLOBAL_STRING_HTMLOUTPUT+="
<p id='$GLOBAL_STRING_SEARCHRESULTID' tabindex='0' class='searchresult-item'
 onclick='parent.popupiframes_hide(); parent.iframe_mapbbox_setsrc(0, \"${GLOBAL_ARRAY_SEARCHRESULT[0]}\");'
 onkeyup='if (event.which == 13) this.onclick(); if (event.which == 27) parent.document.getElementById(\"iframe_search\").contentWindow.document.getElementById(\"search_inputbox\").focus(); if (event.which == 40) this.nextElementSibling.focus(); if (event.which == 38) this.previousElementSibling.focus();'>"
  GLOBAL_STRING_HTMLOUTPUT+=$(convert_escapedstring_html "${GLOBAL_ARRAY_SEARCHRESULT[1]/\\\//\/}")
  GLOBAL_STRING_HTMLOUTPUT+="</p>"
 done
fi

echo "$GLOBAL_STRING_HTMLOUTPUT"

echo "
</body>
</html>"
