#!/bin/bash

### Pop-up IFRAMEs ###

echo "
<!-- ### Pop-up IFRAMEs ### -->

<style>
 iframe.popuphidden1 { z-index: 1; position: absolute; visibility: hidden; top: 0; left:0; width: 0; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
 iframe.popuphidden2 { z-index: 2; position: absolute; visibility: hidden; top: 0; left:0; width: 0; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
</style>

<iframe id='iframe_maptip' class='popuphidden1' onload='iframe_maptip_onload();'></iframe>
<iframe id='iframe_searchresult' class='popuphidden2' onload='iframe_searchresult_onload();'></iframe>
"

### Hide Pop-up IFRAMEs ###

echo "
<!-- Hide Pop-up IFRAMEs -->

<script>

function hide_popupiframes()
{
 document.getElementById('iframe_maptip').style.width = 0;
 document.getElementById('iframe_maptip').style.height = 0;
 document.getElementById('iframe_maptip').style.visibility = 'hidden';
 document.getElementById('iframe_searchresult').style.width = 0;
 document.getElementById('iframe_searchresult').style.height = 0;
 document.getElementById('iframe_searchresult').style.visibility = 'hidden';
}

</script>
"

### MAPTIP setposition & onload  ###

echo "
<!-- MAPTIP setposition & onload -->

<script>

var iframe_maptip_top = 0;
var iframe_maptip_left = 0;

function iframe_maptip_setposition(x, y)
{
 iframe_maptip_top = document.getElementById('iframe_map').getBoundingClientRect().top + y;
 iframe_maptip_left = document.getElementById('iframe_map').getBoundingClientRect().left + x;
}

function iframe_maptip_onload()
{
 document.getElementById('iframe_maptip').style.top = iframe_maptip_top;
 document.getElementById('iframe_maptip').style.left = iframe_maptip_left;
 document.getElementById('iframe_maptip').style.width = document.getElementById('map_maptip').contentWindow.document.body.scrollWidth;
 document.getElementById('iframe_maptip').style.height = document.getElementById('map_maptip').contentWindow.document.body.scrollHeight;
 document.getElementById('iframe_maptip').style.visibility = 'visible';
}

</script>

<script>

searchresult_container_onload_enabled=false;

function searchresult_container_onload()
{
 if ( ! searchresult_container_onload_enabled )
 {
  return false;
 }

 var iframe_searchresult_calculatedheight = document.getElementById('searchresult_container').contentWindow.document.body.scrollWidth;

 if ( iframe_searchresult_calculatedheight <= $CONFIG_SEARCHRESULT_MINIMUMWIDTH )
 {
  document.getElementById('iframe_searchresult').style.width = $CONFIG_SEARCHRESULT_MINIMUMWIDTH;
 }
 else
 {
  document.getElementById('iframe_searchresult').style.width = iframe_searchresult_calculatedheight;
 }

 document.getElementById('iframe_searchresult').style.height = document.getElementById('iframe_searchresult').contentWindow.document.body.scrollHeight;
 document.getElementById('iframe_searchresult').style.visibility = 'visible';
}

</script>
"
