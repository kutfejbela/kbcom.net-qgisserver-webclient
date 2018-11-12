#!/bin/bash

### USE psql instead WFS ###
# QGIS Server WFS have a problem with non US characters and
# does not support srsName and sortBy

convert_spaceseparetedstring_sqllikestring()
{
 local PARAMETER_STRING_STRING="$1"

 local LOCAL_STRING_RESULT

 LOCAL_STRING_RESULT=${PARAMETER_STRING_STRING//\\/\\\\}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//%/\\%}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//_/\\_}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT// /%}

 echo "$LOCAL_STRING_RESULT"
}

convert_spaceseparetedstring_sqlwherestring()
{
 local PARAMETER_STRING_STRING="$1"

 local LOCAL_STRING_RESULT

 LOCAL_STRING_RESULT=${PARAMETER_STRING_STRING// / OR id=}
 LOCAL_STRING_RESULT="id=$LOCAL_STRING_RESULT"

 echo "$LOCAL_STRING_RESULT"
}

request_sql_searchresult()
{
 local PARAMETER_STRING_SEARCHTEXT="$1"

 local LOCAL_STRING_SQLLIKE
 local LOCAL_STRING_SQLQUERY

 LOCAL_STRING_SQLLIKE=$(convert_spaceseparetedstring_sqllikestring "$PARAMETER_STRING_SEARCHTEXT")

 LOCAL_STRING_SQLQUERY="/usr/bin/psql -c \"
  copy (
   select \\\"$CONFIG_SEARCHRESULT_WFSIDFIELD\\\", \\\"$CONFIG_SEARCHRESULT_WFSSEARCHFIELD\\\"
   from \\\"$CONFIG_SEARCHRESULT_WFSLAYER\\\"
   where \\\"cim\\\" ilike '%$LOCAL_STRING_SQLLIKE%'
   order by \\\"$CONFIG_SEARCHRESULT_WFSSEARCHFIELD\\\"
  )
  to stdout with delimiter as E'\\t' null as ''
 \""

 echo "$(eval $LOCAL_STRING_SQLQUERY)"
}

request_sql_bboxbyids()
{
 local PARAMETER_STRING_IDS="$1"

 local LOCAL_STRING_SQLWHERE
 local LOCAL_ROWSTING_RESULT

 LOCAL_STRING_SQLWHERE=$(convert_spaceseparetedstring_sqlwherestring "$PARAMETER_STRING_IDS")

 LOCAL_ROWSTRING_RESULT=$(/usr/bin/psql -c "
copy (
 select st_xmin(\"geom\"), st_ymin(\"geom\"), st_xmax(\"geom\"), st_ymax(\"geom\")
 from \"$CONFIG_MAPIMAGE_WFSLAYER\"
 where $LOCAL_STRING_SQLWHERE
)
to stdout with delimiter as E'\t' null as ''"
 )

 echo "$LOCAL_ROWSTRING_RESULT"
}
