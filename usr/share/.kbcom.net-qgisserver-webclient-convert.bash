#!/bin/bash

convert_real_integer()
{
 local PARAMETER_STRING_DECIMALVALUE="$1"
 local PARAMETER_INTEGER_DECIMAL="$2"

 LOCAL_INTEGER_BASE="${PARAMETER_STRING_DECIMALVALUE%.*}"

 if [ "$PARAMETER_INTEGER_DECIMAL" = "0" ]
 then
  echo "$LOCAL_INTEGER_BASE"
  return
 fi

 LOCAL_INTEGER_DECIMAL="${PARAMETER_STRING_DECIMALVALUE#*.}"

 if [ "$LOCAL_INTEGER_DECIMAL" = "$PARAMETER_STRING_DECIMALVALUE" ]
 then
  LOCAL_INTEGER_DECIMAL=""
 fi

 if [ "${#LOCAL_INTEGER_DECIMAL}" -ge "$PARAMETER_INTEGER_DECIMAL" ]
 then
  echo "$LOCAL_INTEGER_BASE${LOCAL_INTEGER_DECIMAL:0:$PARAMETER_INTEGER_DECIMAL}"
 else
  LOCAL_INTEGER_ZEROSUFFIX=$(( $PARAMETER_INTEGER_DECIMAL - ${#LOCAL_INTEGER_DECIMAL} ))

  for(( LOCAL_INTEGER_INDEX; LOCAL_INTEGER_INDEX<LOCAL_INTEGER_ZEROSUFFIX; LOCAL_INTEGER_INDEX++ ))
  do
   LOCAL_INTEGER_DECIMAL+="0"
  done

  echo "$LOCAL_INTEGER_BASE$LOCAL_INTEGER_DECIMAL"
 fi
}

convert_integer_real()
{
 local PARAMETER_STRING_INTEGERVALUE="$1"
 local PARAMETER_INTEGER_DECIMAL="$2"

 if [ "$PARAMETER_INTEGER_DECIMAL" == "0" ]
 then
  echo "$PARAMETER_STRING_INTEGERVALUE"
 else
  echo "${PARAMETER_STRING_INTEGERVALUE:0:-$PARAMETER_INTEGER_DECIMAL}.${PARAMETER_STRING_INTEGERVALUE: -$PARAMETER_INTEGER_DECIMAL}"
 fi
}

convert_escapedstring_html()
{
 local PARAMETER_STRING_ESCAPEDSTRING="$1"

 local LOCAL_STRING_RESULT

 LOCAL_STRING_RESULT=${PARAMETER_STRING_ESCAPEDSTRING//&/&amp;}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//</&lt;}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\\\/&frasl;}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\t/&#09;}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\n/<br>\\n}

 echo -e "$LOCAL_STRING_RESULT"
}

convert_escapedstring_url()
{
 local PARAMETER_STRING_ESCAPEDSTRING="$1"

 local LOCAL_STRING_RESULT

 LOCAL_STRING_RESULT=${PARAMETER_STRING_ESCAPEDSTRING//\%/%25}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//&/%26}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//=/%3D}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\"/%22}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\'/%27}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\\\/%2F}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\t/%09}
 LOCAL_STRING_RESULT=${LOCAL_STRING_RESULT//\\n/%0A}

 echo -e "$LOCAL_STRING_RESULT"
}

convert_datatemplate_string()
{
 local PARAMETER_STRING_DATATEMPLATE="$1"
 local -n PARAMETER_ROWARRAY_DATA=$2

 local LOCAL_INTEGER_COLUMN
 local LOCAL_STRING_RESULT

 LOCAL_INTEGER_COLUMN="${PARAMETER_STRING_DATATEMPLATE:1:2}"

 if ! check_value_positiveinteger "$LOCAL_INTEGER_COLUMN"
 then
  return
 fi

 LOCAL_STRING_RESULT=""

 case "${PARAMETER_STRING_DATATEMPLATE:0:1}" in
  "r")
   LOCAL_STRING_RESULT="${PARAMETER_ROWARRAY_DATA[$LOCAL_INTEGER_COLUMN]}"
   ;;
  "h")
   LOCAL_STRING_RESULT="$(convert_escapedstring_html "${PARAMETER_ROWARRAY_DATA[$LOCAL_INTEGER_COLUMN]}")"
   ;;
  "u")
   LOCAL_STRING_RESULT="$(convert_escapedstring_url "${PARAMETER_ROWARRAY_DATA[$LOCAL_INTEGER_COLUMN]}")"
   ;;
 esac

 echo "$LOCAL_STRING_RESULT"
}

convert_stringtemplate_string()
{
 local PARAMETER_STRING_TEMPLATE="$1"
 local PARAMETER_ROWSTRING_DATA="$2"

 local LOCAL_STRING_TEMPLATE
 local LOCAL_ROWARRAY_DATA
 local LOCAL_STRING_ADD
 local LOCAL_STRING_RESULT

 LOCAL_STRING_TEMPLATE="$PARAMETER_STRING_TEMPLATE"

 PARAMETER_ROWSTRING_DATA="${PARAMETER_ROWSTRING_DATA//$'\t\t'/$'\t \t'}"
 PARAMETER_ROWSTRING_DATA="${PARAMETER_ROWSTRING_DATA//$'\t\t'/$'\t \t'}"

 IFS=$'\t'
 LOCAL_ROWARRAY_DATA=($PARAMETER_ROWSTRING_DATA)

 LOCAL_STRING_RESULT=""

 while true
 do
  LOCAL_STRING_ADD=${LOCAL_STRING_TEMPLATE%%&*}

  if [ ! -z "$LOCAL_STRING_ADD" ]
  then
   LOCAL_STRING_RESULT+="$LOCAL_STRING_ADD"
  fi

  LOCAL_STRING_TEMPLATE="${LOCAL_STRING_TEMPLATE:${#LOCAL_STRING_ADD}}"

  if [ -z "$LOCAL_STRING_TEMPLATE" ]
  then
   break
  fi

  if [ "${LOCAL_STRING_TEMPLATE:0:2}" = "&:" ]
  then
   LOCAL_STRING_RESULT+=$(convert_datatemplate_string "${LOCAL_STRING_TEMPLATE:2:4}" "LOCAL_ROWARRAY_DATA")
   LOCAL_STRING_TEMPLATE="${LOCAL_STRING_TEMPLATE:6}"
  else
   LOCAL_STRING_RESULT+="&"
   LOCAL_STRING_TEMPLATE="${LOCAL_STRING_TEMPLATE:1}"
  fi
 done

 echo "$LOCAL_STRING_RESULT"
}

convert_bboxstring_zoomlevel()
{
 local PARAMETER_STRING_BBOX="$1"

 local LOCAL_ARRAY_BBOX
 local LOCAL_INTEGER_WIDTH
 local LOCAL_INTEGER_HEIGHT
 local LOCAL_INTEGER_WIDTHMAXIMUM
 local LOCAL_INTEGER_HEIGHTMAXIMUM
 local LOCAL_INTEGER_ZOOMLEVEL
 local LOCAL_INTEGER_ZOOMDIVIDE
 local LOCAL_INTEGER_ZOOMWIDTH
 local LOCAL_INTEGER_ZOOMHEIGHT

 IFS=' '
 LOCAL_ARRAY_BBOX=( $PARAMETER_STRING_BBOX )

 LOCAL_INTEGER_WIDTH=$(( $LOCAL_ARRAY_BBOX{[2]} - $LOCAL_ARRAY_BBOX{[0]} ))
 LOCAL_INTEGER_HEIGHT=$(( $LOCAL_ARRAY_BBOX{[3]} - $LOCAL_ARRAY_BBOX{[1]} ))

 LOCAL_INTEGER_WIDTHMAXIMUM=$(($CONFIG_WMS_MAXIMUMX - $CONFIG_WMS_MINIMUMX))
 LOCAL_INTEGER_HEIGHTMAXIMUM=$(($CONFIG_WMS_MAXIMUMY - $CONFIG_WMS_MINIMUMY))

 for(( LOCAL_INTEGER_ZOOMLEVEL=CONFIG_WMS_ZOOMLEVELMINIMUM; LOCAL_INTEGER_ZOOMLEVEL<=CONFIG_WMS_ZOOMLEVELMAXIMUM; LOCAL_INTEGER_ZOOMLEVEL++ ))
 do
  LOCAL_INTEGER_ZOOMDIVIDE=$(( ($LOCAL_INTEGER_ZOOMLEVEL * $CONFIG_WMS_ZOOMLEVELSTEP) ** 2 ))

  LOCAL_INTEGER_ZOOMWIDTH=$(( $LOCAL_INTEGER_WIDTHMAXIMUM / $LOCAL_INTEGER_ZOOMDIVIDE ))
  LOCAL_INTEGER_ZOOMHEIGHT=$(( $LOCAL_INTEGER_HEIGHTMAXIMUM / $LOCAL_INTEGER_ZOOMDIVIDE ))

  if [ "$LOCAL_INTEGER_WIDTH" -lt "$LOCAL_INTEGER_WIDTHMAXIMUM" ]
  then
   if [ "$LOCAL_INTEGER_HEIGHT" -lt "$LOCAL_INTEGER_HEIGHTMAXIMUM" ]
   then
    echo "$LOCAL_INTEGER_ZOOMLEVEL"
    return
   fi
  fi
 done

 echo "$LOCAL_INTEGER_ZOOMLEVEL"
}

convert_widthzoomxy_bbox()
{
 local PARAMETER_INTEGER_MAPIMAGEWIDTH="$1"
 local PARAMETER_INTEGER_ZOOMLEVEL="$2"
 local PARAMETER_INTEGER_LEFTX="$3"
 local PARAMETER_INTEGER_BOTTOMY="$4"

 local LOCAL_INTEGER_ZOOMDIVIDE
 local LOCAL_INTEGER_ZOOMWIDTH
 local LOCAL_INTEGER_ZOOMHEIGHT
 local LOCAL_BBOX_MINIMUMX
 local LOCAL_BBOX_MAXIMUMX
 local LOCAL_BBOX_MINIMUMY
 local LOCAL_BBOX_MAXIMUMY

 LOCAL_INTEGER_ZOOMDIVIDE=$(( ($PARAMETER_INTEGER_ZOOMLEVEL * $CONFIG_WMS_ZOOMLEVELSTEP) ** 2 ))

 LOCAL_INTEGER_ZOOMWIDTH=$(( ($CONFIG_WMS_MAXIMUMX - $CONFIG_WMS_MINIMUMX) / $LOCAL_INTEGER_ZOOMDIVIDE * $PARAMETER_INTEGER_MAPIMAGEWIDTH / $CONFIG_WMS_IMAGEMAXIMUMWIDTH ))
 LOCAL_INTEGER_ZOOMHEIGHT=$(( ($CONFIG_WMS_MAXIMUMY - $CONFIG_WMS_MINIMUMY) / $LOCAL_INTEGER_ZOOMDIVIDE ))

 LOCAL_BBOX_MINIMUMX=$PARAMETER_INTEGER_LEFTX
 LOCAL_BBOX_MAXIMUMX=$(( $PARAMETER_INTEGER_LEFTX + $LOCAL_INTEGER_ZOOMWIDTH ))
 LOCAL_BBOX_MINIMUMY=$PARAMETER_INTEGER_BOTTOMY
 LOCAL_BBOX_MAXIMUMY=$(( $PARAMETER_INTEGER_BOTTOMY + $LOCAL_INTEGER_ZOOMHEIGHT ))

 if [ "$CONFIG_WMS_COORDINATEDECIMAL" -ne 0 ]
 then
  LOCAL_BBOX_MINIMUMX=$(convert_integer_real "$LOCAL_BBOX_MINIMUMX" "$CONFIG_WMS_COORDINATEDECIMAL")
  LOCAL_BBOX_MAXIMUMX=$(convert_integer_real "$LOCAL_BBOX_MAXIMUMX" "$CONFIG_WMS_COORDINATEDECIMAL")
  LOCAL_BBOX_MINIMUMY=$(convert_integer_real "$LOCAL_BBOX_MINIMUMY" "$CONFIG_WMS_COORDINATEDECIMAL")
  LOCAL_BBOX_MAXIMUMY=$(convert_integer_real "$LOCAL_BBOX_MAXIMUMY" "$CONFIG_WMS_COORDINATEDECIMAL")
 fi

 echo "$LOCAL_BBOX_MINIMUMX,$LOCAL_BBOX_MINIMUMY,$LOCAL_BBOX_MAXIMUMX,$LOCAL_BBOX_MAXIMUMY"
}
