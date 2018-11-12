#!/bin/bash

### Fix IFRAMEs ###

echo "
<!-- ### Fix IFRAMEs ### -->

<style>
 iframe.fixhidden { position: absolute; visibility: hidden; top: 0; left:0; width: 100%; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
</style>

<iframe id='iframe_search' src='$GLOBAL_URL?module=search' class='fixhidden' onload='iframe_search_onload();'></iframe>
<iframe id='iframe_map' src='$GLOBAL_URL?module=map' class='fixhidden' onload='iframe_map_onload();'></iframe>
<iframe id='iframe_html' src='$GLOBAL_URL?module=html' class='fixhidden' onload='iframe_html_onload();'></iframe>
"

### SEARCH onload ###

echo "
<!-- SEARCH onload -->

<script>

var global_iframe_search_sized=false;

function iframe_search_onload()
{
 if (global_iframe_search_sized)
 {
  return;
 }"

if [ "$CONFIG_MAIN_SEARCHSIZE" -eq "0" ]
then
 echo "
 document.getElementById('iframe_search').style.height=document.getElementById('iframe_search').contentWindow.document.body.scrollHeight;"
else
 echo "
 document.getElementById('iframe_search').style.height=$CONFIG_MAIN_SEARCHSIZE";
fi

echo "
 global_iframe_search_sized=true;

 document.getElementById('iframe_map').style.top=document.getElementById('iframe_search').getBoundingClientRect().bottom;
 iframe_html_setpositionandsize();

 document.getElementById('iframe_search').style.visibility='visible';
}

</script>
"


### MAP onload ###

echo "
<!-- MAP onload -->

<script>

var global_iframe_map_sized=false;

function iframe_map_onload()
{
 if (global_iframe_map_sized)
 {
  return;
 }"

if [ "$CONFIG_MAIN_MAPSIZE" -eq "0" ]
then
 echo "
 document.getElementById('iframe_map').style.height=document.getElementById('iframe_map').contentWindow.document.body.scrollHeight;"
else
 echo "
 document.getElementById('iframe_map').style.height=$CONFIG_MAIN_MAPSIZE";
fi

echo "
 global_iframe_map_sized=true;

 iframe_html_setpositionandsize();

 document.getElementById('iframe_map').style.visibility='visible';
}

</script>
"

### HTML setpositionandsize & onload ###

echo "
<!-- HTML setpositionandsize & onload -->

<script>

var global_iframe_html_loaded=false;

function iframe_html_setpositionandsize()
{
 if (!global_iframe_html_loaded)
 {
  return;
 }"

if [ "$CONFIG_MAIN_HTMLSIZE" -eq "0" ]
then
 if [ "$CONFIG_MAIN_HTMLMINIMUMSIZE" -eq "0" ]
 then
  echo "
 document.getElementById('iframe_html').style.height=document.getElementById('iframe_html').contentWindow.document.body.scrollHeight;"
 else
  echo "
 if (!global_iframe_search_sized)
 {
  return;
 }

 if (!global_iframe_map_sized)
 {
  return;
 }

 var local_iframe_map_rect=document.getElementById('iframe_map').getBoundingClientRect();
 var local_iframe_html_calculatedheight=document.getElementById('maincontainer').getBoundingClientRect().bottom - local_iframe_map_rect.bottom;

 document.getElementById('iframe_html').style.top=local_iframe_map_rect.bottom;

 if ( ${CONFIG_MAIN_HTMLMINIMUMSIZE} < local_iframe_html_calculatedheight )
 {
  document.getElementById('iframe_html').style.height=local_iframe_html_calculatedheight;
 }
 else
 {
  document.getElementById('iframe_html').style.height=document.getElementById('iframe_html').contentWindow.document.body.scrollHeight;
 }"
 fi
else
 echo "
 document.getElementById('iframe_html').style.height=$CONFIG_MAIN_HTMLSIZE;"
fi

echo "
 document.getElementById('iframe_html').style.top=document.getElementById('iframe_map').getBoundingClientRect().bottom;
 document.getElementById('iframe_html').style.visibility='visible';
}

function iframe_html_onload()
{
 if (global_iframe_html_loaded)
 {
  return;
 }

 global_iframe_html_loaded=true;
 iframe_html_setpositionandsize();
}

</script>
"
