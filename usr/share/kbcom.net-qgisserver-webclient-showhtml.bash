#!/bin/bash

echo "<style>
$CONFIG_CSS_HTML
</style>"

echo "<table style='margin: auto; border: 0;'>"
echo "<tr style='border: 0;'>"
echo "<td style='border: 0;'>"

printf '\n<!-- HTML template processing has started (%(%c)T) -->\n\n'

for (( GLOBAL_HTML_INDEX=0; GLOBAL_HTML_INDEX<=CONFIG_HTML_COUNT; GLOBAL_HTML_INDEX++ ))
do
 printf '\n<!-- ### HTML template starting, index: %s (%(%c)T) ### -->\n\n' "$GLOBAL_HTML_INDEX"

 if [ "${CONFIG_HTML_ISSTATIC[$GLOBAL_HTML_INDEX]}" = true ]
 then
  printf '\n<!-- HTML template: static, index: %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX"
  echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]}"
 else
  printf '\n<!-- HTML template quering, index: %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX"
  IFS=$'\n'
  GLOBAL_HTML_DATA=$(eval "${CONFIG_HTML_EXECUTE[$GLOBAL_HTML_INDEX]}")

  if [ -z "$GLOBAL_HTML_DATA" ]
  then
   printf '\n<!-- HTML template: empty data, index: %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_EMPTY[$GLOBAL_HTML_INDEX]}"
  else
   printf '\n<!-- HTML template: data header, index: %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_header]}"

   if [ ! -z "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]}" ]
   then
    GLOBAL_DATA_INDEX=0

    for GLOBAL_STRINGDATAROW in $GLOBAL_HTML_DATA
    do
     ((GLOBAL_DATA_INDEX++))
     printf '\n<!-- HTML template: data row, index: %s, %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX" "$GLOBAL_DATA_INDEX"

     declare -a GLOBAL_STRINGDATAROW_ARRAY
     convert_arraydatarow_stringdatarow "$GLOBAL_STRINGDATAROW"

     IFS=''
     echo -e "$(convert_stringhtml_stringtemplate ${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]})"
    done
   fi

   printf '\n<!-- HTML template: data footer, index: %s (%(%c)T) -->\n\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_footer]}"
  fi
 fi
done

printf '\n<!-- HTML template processing has finished (%(%c)T) -->\n\n'

echo "</td>"
echo "</tr>"
echo "</table>"
