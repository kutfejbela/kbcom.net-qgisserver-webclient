#!/bin/bash

echo "<iframe id='map_maptip' style='position: absolute; z-index: 1; visibility: hidden; width: 0; height: 0; margin: 0; padding: 0; border: #cccccc 1px solid;' onload='map_maptip_onload();' onresize='wms_hideflowframes();'></iframe>"
echo "<iframe id='searchresult_container' style='visibility: hidden; position: absolute; z-index: 2;' class='searchresult-container' onload='searchresult_container_onload();'></iframe>"

echo "<script>

searchresult_container_onload_enabled=false;

function map_maptip_onload()
{
 document.getElementById('map_maptip').style.width=document.getElementById('map_maptip').contentWindow.document.body.scrollWidth;
 document.getElementById('map_maptip').style.height=document.getElementById('map_maptip').contentWindow.document.body.scrollHeight;
 document.getElementById('map_maptip').style.visibility=\"visible\";
}

function searchresult_container_onload()
{
 if ( ! searchresult_container_onload_enabled )
 {
  return false;
 }

 var local_contentwidth=document.getElementById('searchresult_container').contentWindow.document.body.scrollWidth;

 if ( local_contentwidth <= $CONFIG_SEARCHRESULT_MINIMUMWIDTH )
 {
  document.getElementById('searchresult_container').style.width=$CONFIG_SEARCHRESULT_MINIMUMWIDTH;
 }
 else
 {
  document.getElementById('searchresult_container').style.width=local_contentwidth;
 }

 document.getElementById('searchresult_container').style.height=document.getElementById('searchresult_container').contentWindow.document.body.scrollHeight;
 document.getElementById('searchresult_container').style.visibility='visible';
}

</script>"
