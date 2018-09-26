#!/bin/bash

### SEARCH head & style classes ###

echo "
<!-- SEARCH head & style classes -->
<html>
<head>
<title>Search</title>
<style>
$CONFIG_CSS_SEARCH
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1'>
"

### SEARCH inputbox & help ###

echo "
<!-- SEARCH inputbox & help -->

<input tabindex='0' type='text' id='search_inputbox' placeholder='${CONFIG_SEARCH_LABEL}' class='search-inputbox' onkeyup='search_inputbox_onkeyup(event);'><br>
<label class='search-help'>${CONFIG_SEARCH_HELP}</label>
"

### SEARCH inputbox onkeyup & onfocus ###

echo "
<!-- SEARCH inputbox onkeyup & onfocus -->

<script>

function search_inputbox_onkeyup(event)
{
  var local_search_inputbox_rect = document.getElementById('search_inputbox').getBoundingClientRect();
  var local_search_inputbox_text = document.getElementById('search_inputbox').value.trim();
  var local_search_inputbox_textlength = local_search_inputbox_text.length;

  parent.iframe_searchresult_hide();

  if ( local_search_inputbox_textlength < 4 )
  {
   return;
  }

  if ( 30 < local_search_inputbox_textlength )
  {
   document.getElementById('search_inputbox').value = local_search_inputbox_text.substring(0, 30);
   return;
  }

  parent.iframe_searchresult_setposition(local_search_inputbox_rect.left, local_search_inputbox_rect.bottom);
  parent.iframe_searchresult_setsrc(local_search_inputbox_text);
//  parent.document.getElementById('iframe_searchresult').src='${GLOBAL_URL}?type=searchresult&searchtext=' + search_inputbox_text;
 }

</script>"
