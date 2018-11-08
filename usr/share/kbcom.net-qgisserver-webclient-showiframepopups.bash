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
 document.getElementById('iframe_maptip').style.width=0;
 document.getElementById('iframe_maptip').style.height=0;
 document.getElementById('iframe_maptip').style.visibility='hidden';
 document.getElementById('iframe_searchresult').style.width=0;
 document.getElementById('iframe_searchresult').style.height=0;
 document.getElementById('iframe_searchresult').style.visibility='hidden';
}

</script>
"

### SEARCHRESULT hide, setposition, setsrc & onload ###

echo "
<!-- SEARCHRESULT hide, setposition, setsrc & onload -->

<script>

function iframe_searchresult_hide()
{
 document.getElementById('iframe_searchresult').style.width=0;
 document.getElementById('iframe_searchresult').style.height=0;
 document.getElementById('iframe_searchresult').style.visibility='hidden';
}

function iframe_searchresult_setposition(parameter_integer_x, parameter_integer_y)
{
 document.getElementById('iframe_searchresult').style.left=document.getElementById('iframe_search').offsetLeft + parameter_integer_x;
 document.getElementById('iframe_searchresult').style.top=document.getElementById('iframe_search').offsetTop + parameter_integer_y;
}

function iframe_searchresult_setsrc(parameter_string_searchtext)
{
 var local_string_searchtext;

 local_string_searchtext=parameter_string_searchtext.replace('%','%25');
 local_string_searchtext=local_string_searchtext.replace('&','%26');
 local_string_searchtext=local_string_searchtext.replace('\t','%09');

 document.getElementById('iframe_searchresult').src='$GLOBAL_URL?module=searchresult&searchtext=' + local_string_searchtext;
}

function iframe_searchresult_onload()
{
 var local_integer_contentwidth=document.getElementById('iframe_searchresult').contentWindow.document.body.scrollWidth;
 var local_integer_contentheight=document.getElementById('iframe_searchresult').contentWindow.document.body.scrollHeight;

 if ( local_integer_contentwidth <= $CONFIG_SEARCHRESULT_MINIMUMWIDTH )
 {
  document.getElementById('iframe_searchresult').style.width=$CONFIG_SEARCHRESULT_MINIMUMWIDTH;
 }
 else
 {
  document.getElementById('iframe_searchresult').style.width=local_integer_contentwidth;
 }

 if ( $CONFIG_SEARCHRESULT_MAXIMUMHEIGHT <= local_integer_contentheight )
 {
  document.getElementById('iframe_searchresult').style.height=$CONFIG_SEARCHRESULT_MAXIMUMHEIGHT;
 }
 else
 {
  document.getElementById('iframe_searchresult').style.height=local_integer_contentheight;
 }

 document.getElementById('iframe_searchresult').style.visibility='visible';
}

</script>
"

### MAPTIP setposition, setsrc & onload  ###

echo "
<!-- MAPTIP setposition, setsrc & onload -->

<script>

function iframe_maptip_setposition(parameter_integer_x, parameter_integer_y)
{
 document.getElementById('iframe_maptip').style.left=document.getElementById('iframe_map').offsetLeft + parameter_integer_x;
 document.getElementById('iframe_maptip').style.top=document.getElementById('iframe_map').offsetTop + parameter_integer_y;
}

function iframe_maptip_setsrc(parameter_integer_imagewidth, parameter_integer_zoomlevel, parameter_integer_leftx, parameter_integer_bottomy, parameter_integer_x, parameter_integer_y)
{
 document.getElementById('iframe_maptip').src='$GLOBAL_URL?module=maptip&mapimagewidth=' + parameter_integer_imagewidth + '&zoomlevel=' + parameter_integer_zoomlevel + '&leftx=' + parameter_integer_leftx + '&bottomy=' + parameter_integer_bottomy + '&x=' + parameter_integer_x + '&y=' + parameter_integer_y;
}

function iframe_maptip_onload()
{
 document.getElementById('iframe_maptip').style.width=document.getElementById('iframe_maptip').contentWindow.document.body.scrollWidth;
 document.getElementById('iframe_maptip').style.height=document.getElementById('iframe_maptip').contentWindow.document.body.scrollHeight;
 document.getElementById('iframe_maptip').style.visibility='visible';
}

</script>
"
