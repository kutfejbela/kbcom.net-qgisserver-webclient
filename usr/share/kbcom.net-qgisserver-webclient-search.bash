#!/bin/bash

echo "Content-type: text/html;charset=UTF-8"
echo

### SEARCH head & style classes ###

echo "
<!-- SEARCH head & style classes -->
<html>
<head>
<title>$CONFIG_MAIN_TITLE - Search</title>
<style>
$CONFIG_SEARCH_CSS
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1' onclick='parent.popupiframes_hide();'>
"

### SEARCH inputbox & help ###

echo "
<!-- SEARCH inputbox & help -->

<span class='search-title'>$CONFIG_SEARCH_TITLE</span>
<span class='search-inputboxhelp'>
<input tabindex='0' type='text' id='search_inputbox' placeholder='$CONFIG_SEARCH_LABELHTMLVALUE' maxlength='$CONFIG_SEARCH_MAXIMUMCHARACTER' class='search-inputbox' onkeyup='search_inputbox_onkeyup(event);' onfocus='search_inputbox_onkeyup(event);'><br>
$CONFIG_SEARCH_HELPHTML
</span>
"

### SEARCH inputbox onkeyup & onfocus ###

echo "
<!-- SEARCH inputbox onkeyup & onfocus -->

<script>

function search_inputbox_onkeyup(parameter_object_event)
{
 var local_search_jumptosearchresult;
 var local_search_inputbox_rect;
 var local_search_inputbox_text=document.getElementById('search_inputbox').value.trim();
 var local_search_inputbox_textlength=local_search_inputbox_text.length;

 if ( local_search_inputbox_textlength < $CONFIG_SEARCH_MINIMUMCHARACTER )
 {
  return false;
 }"

if [ -z "$CONFIG_SEARCH_AUTOSEARCH" ]
then
 echo "
 parent.iframe_searchresult_hide();

 if (parameter_object_event.which != 13)
 {
  return false;
 }

 local_search_jumptosearchresult=true;"
else
 echo "
 if (parameter_object_event.which == 13 || parameter_object_event.which == 40 )
 {
  parent.iframe_searchresult_focus();
  return false;
 }

 parent.iframe_searchresult_hide();
 local_search_jumptosearchresult=false;"
fi

echo "
 local_search_inputbox_rect=document.getElementById('search_inputbox').getBoundingClientRect();

 parent.iframe_searchresult_setposition(local_search_inputbox_rect.left, local_search_inputbox_rect.bottom);
 parent.iframe_searchresult_setsrc(local_search_inputbox_text, local_search_jumptosearchresult);

 return false;
}
</script>

</body>
</html>"

