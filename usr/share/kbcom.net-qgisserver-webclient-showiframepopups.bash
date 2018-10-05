#!/bin/bash

### Pop-up IFRAMEs ###

echo "
<!-- ### Pop-up IFRAMEs ### -->

<style>
 iframe.popuphidden1 { z-index: 1; position: absolute; visibility: hidden; top: 0; left:0; width: 0; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
 iframe.popuphidden2 { z-index: 2; position: absolute; visibility: hidden; top: 0; left:0; width: 0; height: 0; margin: 0; padding: 0; border: 0; background-color: transparent; }
</style>

<iframe id='iframe_searchresult' class='popuphidden2' onload='iframe_searchresult_onload();'></iframe>
<iframe id='iframe_maptip' class='popuphidden1' onload='iframe_maptip_onload();'></iframe>
"

### Hide Pop-up IFRAMEs ###

echo "
<!-- Hide Pop-up IFRAMEs -->

<script>

function popupiframes_hide()
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

### SEARCHRESULT setposition & onload ###

echo "
<!-- SEARCHRESULT hide, setposition & onload -->

<script>

function iframe_searchresult_hide()
{
 document.getElementById('iframe_searchresult').style.width = 0;
 document.getElementById('iframe_searchresult').style.height = 0;
 document.getElementById('iframe_searchresult').style.visibility = 'hidden';
}

function iframe_searchresult_setposition(parameter_x, parameter_y)
{
 document.getElementById('iframe_searchresult').style.left = parameter_x;
 document.getElementById('iframe_searchresult').style.top = parameter_y;
}

function iframe_searchresult_setsrc(parameter_searchtext)
{
 var local_searchtext;

 local_searchtext = parameter_searchtext.replace('%','%25');
 local_searchtext = local_searchtext.replace('&','%26');
 local_searchtext = local_searchtext.replace('\t','%09');

 document.getElementById('iframe_searchresult').src='$GLOBAL_URL?module=searchresult&searchtext=' + local_searchtext;
}

function iframe_searchresult_onload()
{
 var local_iframe_searchresult_calculatedwidth = document.getElementById('iframe_searchresult').contentWindow.document.body.scrollWidth;
 var local_iframe_searchresult_calculatedheight = document.getElementById('iframe_searchresult').contentWindow.document.body.scrollHeight;

 if ( local_iframe_searchresult_calculatedwidth <= $CONFIG_SEARCHRESULT_MINIMUMWIDTH )
 {
  document.getElementById('iframe_searchresult').style.width = $CONFIG_SEARCHRESULT_MINIMUMWIDTH;
 }
 else
 {
  document.getElementById('iframe_searchresult').style.width = local_iframe_searchresult_calculatedwidth;
 }

 if ( $CONFIG_SEARCHRESULT_MAXIMUMHEIGHT <= local_iframe_searchresult_calculatedheight )
 {
  document.getElementById('iframe_searchresult').style.height = $CONFIG_SEARCHRESULT_MAXIMUMHEIGHT;
 }
 else
 {
  document.getElementById('iframe_searchresult').style.height = local_iframe_searchresult_calculatedheight;
 }

 document.getElementById('iframe_searchresult').style.visibility = 'visible';
}

</script>
"

### MAPTIP setposition & onload  ###

echo "
<!-- MAPTIP setposition & onload -->

<script>

function iframe_maptip_setposition(parameter_x, parameter_y)
{
 document.getElementById('iframe_maptip').style.left = parameter_x;
 document.getElementById('iframe_maptip').style.top = parameter_y;
}

function iframe_maptip_onload()
{
 document.getElementById('iframe_maptip').style.width = document.getElementById('iframe_maptip').contentWindow.document.body.scrollWidth;
 document.getElementById('iframe_maptip').style.height = document.getElementById('iframe_maptip').contentWindow.document.body.scrollHeight;
 document.getElementById('iframe_maptip').style.visibility = 'visible';
}

</script>
"
