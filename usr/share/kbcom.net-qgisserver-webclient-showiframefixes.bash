#!/bin/bash

### Fix IFRAMEs ###

echo "
<!-- ### Fix IFRAMEs ### -->

<style>
 iframe.fixhidden { position: absolute; visibility: hidden; top: 0; left:0; width: 100%; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
</style>

<iframe id='iframe_search' src='$GLOBAL_URL?type=showsearch' class='fixhidden' onload='iframe_search_onload();'></iframe>
<iframe id='iframe_map' src='$GLOBAL_URL?type=showmap' class='fixhidden' onload='iframe_map_onload();'></iframe>
<iframe id='iframe_html' src='$GLOBAL_URL?type=showhtml' class='fixhidden' onload='iframe_html_onload();'></iframe>
"

### SEARCH onload ###

echo "
<!-- SEARCH onload -->

<script>

var iframe_search_sized = false;

function iframe_search_onload()
{
 if (iframe_search_sized)
 {
  return;
 }"

if [ -z "$CONFIG_MAIN_SEARCHSIZE" ] || [ "$CONFIG_MAIN_SEARCHSIZE" -eq "0" ]
then
 echo "
 document.getElementById('iframe_search').style.height = document.getElementById('iframe_search').contentWindow.document.body.scrollHeight;"
else
 echo "
 document.getElementById('iframe_search').style.height = $CONFIG_MAIN_SEARCHSIZE";
fi

echo "
 iframe_search_sized = true;

 document.getElementById('iframe_map').style.top = document.getElementById('iframe_search').getBoundingClientRect().bottom;
 iframe_html_setpositionandsize();

 document.getElementById('iframe_search').style.visibility = 'visible';
}

</script>
"


### MAP onload ###

echo "
<!-- MAP onload -->

<script>

var iframe_map_sized = false;

function iframe_map_onload()
{
 if (iframe_map_sized)
 {
  return;
 }"

if [ -z "$CONFIG_MAIN_MAPSIZE" ] || [ "$CONFIG_MAIN_MAPSIZE" -eq "0" ]
then
 echo "
 document.getElementById('iframe_map').style.height = document.getElementById('iframe_map').contentWindow.document.body.scrollHeight;"
else
 echo "
 document.getElementById('iframe_map').style.height = $CONFIG_MAIN_MAPSIZE";
fi

echo "
 iframe_map_sized = true;

 iframe_html_setpositionandsize();

 document.getElementById('iframe_map').style.visibility = 'visible';
}

</script>
"

### HTML onload & setpositionandsize ###

echo "
<!-- HTML onload & setpositionandsize -->

<script>

var iframe_html_loaded = false;

function iframe_html_onload()
{
 if (iframe_html_loaded)
 {
  return;
 }

 iframe_html_loaded = true;
 iframe_html_setpositionandsize();
}

function iframe_html_setpositionandsize()
{
 if (!iframe_html_loaded)
 {
  return;
 }"

if [ -z "$CONFIG_MAIN_HTMLSIZE" ] || [ "$CONFIG_MAIN_HTMLSIZE" -eq "0" ]
then
 if [ -z "$CONFIG_MAIN_HTMLMINIMUMSIZE" ] || [ "$CONFIG_MAIN_HTMLMINIMUMSIZE" -eq "0" ]
 then
  echo "
 document.getElementById('iframe_html').style.height = document.getElementById('iframe_html').contentWindow.document.body.scrollHeight;"
 else
  echo "
 if (!iframe_search_sized)
 {
  return;
 }

 if (!iframe_map_sized)
 {
  return;
 }

 var iframe_map_rect = document.getElementById('iframe_map').getBoundingClientRect();
 var iframe_html_calculatedheight = document.getElementById('div_container').getBoundingClientRect().bottom - iframe_map_rect.bottom;

 document.getElementById('iframe_html').style.top = iframe_map_rect.bottom;

 if ( ${CONFIG_MAIN_HTMLMINIMUMSIZE} < iframe_html_calculatedheight )
 {
  document.getElementById('iframe_html').style.height = iframe_html_calculatedheight;
 }
 else
 {
  document.getElementById('iframe_html').style.height = document.getElementById('iframe_html').contentWindow.document.body.scrollHeight;
 }"
 fi
else
 echo "
 document.getElementById('iframe_html').style.height = $CONFIG_MAIN_HTMLSIZE;"
fi

echo "
 document.getElementById('iframe_html').style.top = document.getElementById('iframe_map').getBoundingClientRect().bottom;
 document.getElementById('iframe_html').style.visibility = 'visible';
}

</script>
"
