#!/bin/bash

echo "<style>
$CONFIG_SEARCH_STYLE
</style>"

SHELL_GET_SEARCHTEXT=$(shell_get_value "searchtext")
SHELL_GET_SEARCHTEXT=${SHELL_GET_SEARCHTEXT//%/\\x}
SHELL_GET_SEARCHTEXT=$(echo -e "$SHELL_GET_SEARCHTEXT")

GLOBAL_SQL_WHERE=""

IFS=' '
for GLOBAL_SEARCHWORD in $SHELL_GET_SEARCHTEXT
do
 GLOBAL_SQL_WHERE+=" ( \"$CONFIG_DB_SEARCHFIELD\" ilike '$GLOBAL_SEARCHWORD%'"
 GLOBAL_SQL_WHERE+=" or \"$CONFIG_DB_SEARCHFIELD\" ilike '% $GLOBAL_SEARCHWORD%'"
 GLOBAL_SQL_WHERE+=" or \"$CONFIG_DB_SEARCHFIELD\" ilike '%-$GLOBAL_SEARCHWORD%' ) "
 GLOBAL_SQL_WHERE+="and"
done

GLOBAL_SQL_WHERE=${GLOBAL_SQL_WHERE:0:-3}

GLOBAL_SQL_RESULT=`/usr/bin/psql -t -c "
 copy (
  select \"id\", \"$CONFIG_DB_SEARCHFIELD\"
  from \"$CONFIG_DB_TABLE\"
  where $GLOBAL_SQL_WHERE
  order by \"$CONFIG_DB_SEARCHFIELD\"
  limit $(( $CONFIG_SEARCHRESULT_MAXIMUMITEMNUMBER + 1 ))
  )
  to stdout with delimiter as '\"' null as ''
 "`

GLOBAL_SEARCHRESULT_ITEMCOUNTER=0

IFS=$'\n'
for GLOBAL_SQL_RESULTROW in $GLOBAL_SQL_RESULT
do
 let "GLOBAL_SEARCHRESULT_ITEMCOUNTER++"

 if [ $GLOBAL_SEARCHRESULT_ITEMCOUNTER -gt $CONFIG_SEARCHRESULT_MAXIMUMITEMNUMBER ]
 then
  echo "<span class='searchresult-maximumitem'>$CONFIG_SEARCHRESULT_MORETHANMAXIMUMITEMTEXT</span>"
  break
 fi

 GLOBAL_SQL_RESULTROWDELIMITER=$( expr index "$GLOBAL_SQL_RESULTROW" '"')

 echo "<span
  class='searchresult-item'
  onclick='parent.document.getElementById(\"map\").src=\"$GLOBAL_URL?type=showmap&id=${GLOBAL_SQL_RESULTROW:0:GLOBAL_SQL_RESULTROWDELIMITER - 1}\";
   parent.document.getElementById(\"search_result\").style.visible=\"hidden\";'>"
 echo -e "${GLOBAL_SQL_RESULTROW:GLOBAL_SQL_RESULTROWDELIMITER}"
 echo "</span><br>"
done

if [ "$GLOBAL_SEARCHRESULT_ITEMCOUNTER" -eq "0" ]
then
  echo "<span class='searchresult-maximumitem'>$CONFIG_SEARCHRESULT_NONETEXT</span>"
fi
