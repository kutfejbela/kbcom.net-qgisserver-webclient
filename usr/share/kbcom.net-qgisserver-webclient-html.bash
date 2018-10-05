#!/bin/bash

### HTML head & style classes ###

echo "
<!-- HTML head & style classes -->
<html>
<head>
<title>$CONFIG_MAIN_TITLE - HTML</title>
<style>
$CONFIG_HTML_CSS
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1'>
"

echo "<table style='margin: auto; border: 0;'>"
echo "<tr style='border: 0;'>"
echo "<td style='border: 0;'>"

printf '\n\n<!-- HTML template processing has started (%(%c)T) -->\n'

for (( GLOBAL_HTML_INDEX=0; GLOBAL_HTML_INDEX<=CONFIG_HTML_COUNT; GLOBAL_HTML_INDEX++ ))
do
 printf '\n\n<!-- ### HTML template starting, index: %s (%(%c)T) ### -->\n' "$GLOBAL_HTML_INDEX"

 if [ "${CONFIG_HTML_ISSTATIC[$GLOBAL_HTML_INDEX]}" = true ]
 then
  printf '\n\n<!-- HTML template: static, index: %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX"
  echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]}"
 else
  printf '\n\n<!-- HTML template quering, index: %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX"
  IFS=$'\n'
  GLOBAL_DBSTRING_DATA=$(eval "${CONFIG_HTML_EXECUTE[$GLOBAL_HTML_INDEX]}")

  if [ -z "$GLOBAL_DBSTRING_DATA" ]
  then
   printf '\n\n<!-- HTML template: empty data, index: %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_EMPTY[$GLOBAL_HTML_INDEX]}"
  else
   printf '\n\n<!-- HTML template: data header, index: %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_header]}"

   if [ ! -z "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]}" ]
   then
    GLOBAL_DATA_INDEX=0

    for GLOBAL_ROWSTRING_DATA in $GLOBAL_DBSTRING_DATA
    do
     ((GLOBAL_DATA_INDEX++))
     printf '\n\n<!-- HTML template: data row, index: %s, %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX" "$GLOBAL_DATA_INDEX"

     IFS=''
     echo "$(convert_stringtemplate_string "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_body]}" "$GLOBAL_ROWSTRING_DATA")"
    done
   fi

   printf '\n\n<!-- HTML template: data footer, index: %s (%(%c)T) -->\n' "$GLOBAL_HTML_INDEX"
   echo -e "${CONFIG_HTML_TEMPLATE[$GLOBAL_HTML_INDEX,html_footer]}"
  fi
 fi
done

printf '\n\n<!-- HTML template processing has finished (%(%c)T) -->\n'

echo "</td>"
echo "</tr>"
echo "</table>"

echo "
</body>
</html>"
