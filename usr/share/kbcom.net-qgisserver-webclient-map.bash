#!/bin/bash

echo "Content-type: text/html;charset=UTF-8"
echo

### MAP head & style classes ###

echo "
<!-- MAP head & style classes -->
<html>
<head>
<title>$CONFIG_MAIN_TITLE - Map</title>
<style>
$CONFIG_MAP_CSS
</style>
<meta charset='UTF-8'>
</head>
<body tabindex='-1'>
"

### HTML GET id & gid ###

SHELL_GET_ID=$(shell_get_value "id")
SHELL_GET_GID=$(shell_get_value "otherid")

GLOBAL_INTEGER_LEFTX=$CONFIG_WMS_DEFAULTLEFTX
GLOBAL_INTEGER_TOPY=$CONFIG_WMS_DEFAULTTOPY

SHELLGET_INTEGER_ZOOMLEVEL=$CONFIG_WMS_DEFAULTZOOMLEVEL


GLOBAL_STRING_GEOMARRAY=""

if [ ! -z "$SHELL_GET_ID" ]
then
 GLOBAL_STRING_GEOMARRAY=$(get_geomarray_featureid "$SHELL_GET_ID")
fi

if [ ! -z "$SHELL_GET_GID" ]
then
 GLOBAL_STRING_GEOMARRAY=$(get_geomarray_featuregroupid "$SHELL_GET_GID")
fi

if [ ! -z "$GLOBAL_STRING_GEOMARRAY" ]
then
 IFS=' '
 GLOBAL_ARRAY_MAPBOX=( $(convert_mapbox_geomarray "$GLOBAL_STRING_GEOMARRAY") )

 if [ -z "${GLOBAL_ARRAY_MAPBOX[*]}" ]
 then
  SHELL_GET_ID=""
 else
  GLOBAL_CENTERX="${GLOBAL_ARRAY_MAPBOX[0]}"
  GLOBAL_CENTERY="${GLOBAL_ARRAY_MAPBOX[1]}"
  SHELLGET_INTEGER_ZOOMLEVEL="${GLOBAL_ARRAY_MAPBOX[2]}"
 fi
fi

if [ -z "$SHELL_GET_ID" ]
then
 GLOBAL_CENTERX="$CONFIG_WMS_DEFAULTCENTERX"
 GLOBAL_CENTERY="$CONFIG_WMS_DEFAULTCENTERY"
 GLOBAL_ZOOMLEVEL="$CONFIG_WMS_DEFAULTZOOMLEVEL"
fi

### HTML tags: mapimage, map help and map legend ###

echo "
<!-- HTML tags: mapimage, map help and map legend -->

<img tabindex='0' id='mapimage' draggable='false'"

if [ -z "$CONFIG_WMS_IMAGEWIDTH" ]
then
 echo -n " width='100%'"
else
 echo -n " width='$CONFIG_WMS_IMAGEWIDTH'"
fi

echo " height='$CONFIG_WMS_IMAGEHEIGHT'
 style='display: block; margin: 0 auto; padding: 0; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none;'
 onload='mapimage_onload();' onkeyup='mapimage_onkeyup(event);'
 ondragstart='return false;' onwheel='mapimage_onwheel(this, event); return false;' onmousedown='mapimage_onmousedown(this, event);' onmouseup='mapimage_onmouseup(this, event);' onmouseleave='mapimage_onmouseleave(this, event);'
 ><br>

<span class='map-help'>$CONFIG_MAP_HELPHTML</span>
<span class='map-legend'>$CONFIG_MAP_LEGENDHTML</span>"

### HTML script ###

echo "
<!-- HTML script -->
<script>"

### HTML script: set variables and image size (if necessary) from config ###

echo "
// ### HTML script: set variables and image size (if necessary) from config ###

document.getElementById('mapimage').addEventListener('wheel', function(){
 mapimage_onwheel(this, event);
 event.preventDefault();
});

var global_integer_minimumx=$CONFIG_WMS_MINIMUMX;
var global_integer_maximumx=$CONFIG_WMS_MAXIMUMX;
var global_integer_minimumy=$CONFIG_WMS_MINIMUMY;
var global_integer_maximumy=$CONFIG_WMS_MAXIMUMY;

var global_integer_defaultwidth=$CONFIG_WMS_DEFAULTWIDTH;
var global_integer_defaultheight=$CONFIG_WMS_DEFAULTHEIGHT;

var global_integer_zoomlevel=$SHELLGET_INTEGER_ZOOMLEVEL;
var global_integer_zoomlevelminimum=$CONFIG_WMS_ZOOMLEVELMINIMUM;
var global_integer_zoomlevelmaximum=$CONFIG_WMS_ZOOMLEVELMAXIMUM;"

if [ -z "$CONFIG_WMS_IMAGEWIDTH" ]
then
 echo "
if ( $CONFIG_WMS_IMAGEMAXWIDTH < document.getElementById('mapimage').width )
{
 document.getElementById('mapimage').style.width=$CONFIG_WMS_IMAGEMAXWIDTH;
 document.getElementById('mapimage').style.margin='0 auto';
}"
fi

### HTML script: set variables from HTML GET ###

echo "
// ### HTML script: set variables from HTML GET ###

var global_integer_leftx=$GLOBAL_INTEGER_LEFTX;
var global_integer_topy=$GLOBAL_INTEGER_TOPY;"

### HTML script: calculate variables ###

echo "
// ### HTML script: calculate variables ###

var global_integer_maxwidth=global_integer_maximumx - global_integer_minimumx;
var global_integer_maxheight=global_integer_maximumy - global_integer_minimumy;

var global_real_zoomlevelstepsquare=Math.pow($CONFIG_WMS_ZOOMLEVELSTEP, 2);
var global_real_movepercentage=$CONFIG_WMS_MOVEPERCENTAGE/100;

var global_integer_zoomwidth=Math.round(global_integer_defaultwidth / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare);
var global_integer_zoomheight=Math.round(global_integer_defaultheight / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare);

var global_integer_movex=Math.round(global_integer_zoomwidth * global_real_movepercentage);
var global_integer_movey=Math.round(global_integer_zoomheight * global_real_movepercentage);

//var global_real_wmsaspectratio=global_real_width / global_real_height;
//var global_real_imageaspectratio=document.getElementById('mapimage').width / document.getElementById('mapimage').height;"

### HTML script: set other variables ###

echo "
// ### HTML script: set other variables ###

var global_boolean_blockpanzoom=false;
var global_boolean_blockzoom=false;

//var global_drag_startx=0;
//var global_drag_starty=0;
//var global_is_dragdrop=false;
//var global_drag_interval;"

### HTML script: calculate zoom and show mapimage ###

echo "
// ### HTML script: calculate zoom and show mapimage ###

mapimage_setsrc();

function mapimage_checkx()
{
 var local_integer_maximumx;

 if (global_integer_zoomwidth > global_integer_maxwidth)
 {
  return;
 }

 if ( global_integer_leftx < global_integer_minimumx )
 {
  global_integer_leftx=global_integer_minimumx;
  return;
 }

 local_integer_maximumx=global_integer_maximumx - global_integer_zoomwidth;

 if ( local_integer_maximumx < global_integer_leftx )
 {
  global_integer_leftx=local_integer_maximumx;
  return;
 }
}

function mapimage_checky()
{
 var local_integer_maximumy;

 if (global_integer_zoomheight > global_integer_maxheight)
 {
  return;
 }

 if ( global_integer_topy < global_integer_minimumy )
 {
  global_integer_topy=global_integer_minimumy;
  return;
 }

 local_integer_maximumy=global_integer_maximumy - global_integer_zoomheight;

 if ( local_integer_maximumy < global_integer_topy )
 {
  global_integer_topy=local_integer_maximumy;
  return;
 }
}

function mapimage_setsrc()
{
 global_block_zoompan=true;

//alert('$GLOBAL_URL?module=mapimage&zoomlevel=' + global_integer_zoomlevel + '&leftx=' + global_integer_leftx + '&topy=' + global_integer_topy);
 document.getElementById('mapimage').src='$GLOBAL_URL?module=mapimage&zoomlevel=' + global_integer_zoomlevel + '&leftx=' + global_integer_leftx + '&topy=' + global_integer_topy;
}

function mapimage_pandelta()
{
 if ( global_zoom_centery <= global_centery_min )
 {
  global_centery=global_centery_min;
 }
 else
 {
  global_centery=global_zoom_centery;
 }

 if ( global_centery_max <= global_zoom_centery )
 {
  global_centery=global_centery_max;
 }
 else
 {
  global_centery=global_zoom_centery;
 }

 if ( global_zoom_centerx <= global_centerx_min )
 {
  global_centerx=global_centerx_min;
 }
 else
 {
  global_centerx=global_zoom_centerx;
 }

 if ( global_centerx_max <= global_zoom_centerx )
 {
  global_centerx=global_centery_max;
 }
 else
 {
  global_centerx=global_zoom_centerx;
 }
}


function mapimage_click(object, event)
{
 var imgX = event.clientX - Math.floor(object.getBoundingClientRect().left);
 var imgY = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(object.getBoundingClientRect().top);
 var clickX = event.clientX + document.body.scrollLeft + document.documentElement.scrollLeft + Math.floor(parent.document.getElementById('map').getBoundingClientRect().left);
 var clickY = event.clientY + document.body.scrollTop + document.documentElement.scrollTop + parent.document.documentElement.scrollTop + Math.floor(parent.document.getElementById('map').getBoundingClientRect().top);

 // if ( imgX < ${CONFIG_WMS_MAPIMAGEWIDTH} ) ${CONFIG_WMS_MAPIMAGEHEIGHT}
// parent.document.getElementById('iframe_maptip').style.left=clickX;
// parent.document.getElementById('iframe_maptip').style.top=clickY;
// parent.document.getElementById('iframe_maptip').style.width=0;
// parent.document.getElementById('iframe_maptip').style.height=0;
// parent.document.getElementById('iframe_maptip').src='$GLOBAL_URL?module=wmsmaptip&zoomlevel=' + global_zoomlevel + '&centerx=' + global_centerx + '&centery=' + global_centery + '&x=' + imgX + '&y=' + imgY;
// document.getElementById('mapimageurl').value='$GLOBAL_URL?module=wmsmaptip&zoomlevel=' + global_zoomlevel + '&centerx=' + global_centerx + '&centery=' + global_centery + '&x=' + imgX + '&y=' + imgY;
}"

### HTML script: mapimage pan & zoom ###

echo "
// ### HTML script: mapimage pan & zoom ###

function mapimage_zoomin()
{
 var local_real_zoominwidth;
 var local_real_zoominheight;

 if ( global_integer_zoomlevelmaximum <= global_integer_zoomlevel )
 {
  return;
 }

 global_integer_zoomlevel++;

 local_real_zoominwidth=global_integer_defaultwidth / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare;
 local_real_zoominheight=global_integer_defaultheight / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare;

 global_integer_leftx=Math.round(global_integer_leftx + ( (global_integer_zoomwidth - local_real_zoominwidth) / 2 ));
 global_integer_topy=Math.round(global_integer_topy + ( (global_integer_zoomheight - local_real_zoominheight) / 2 ));

 global_integer_zoomwidth=Math.round(local_real_zoominwidth);
 global_integer_zoomheight=Math.round(local_real_zoominheight);
 global_integer_movex=Math.round(global_integer_zoomwidth * global_real_movepercentage);
 global_integer_movey=Math.round(global_integer_zoomheight * global_real_movepercentage);

 mapimage_setsrc();
}

function mapimage_zoomout()
{
 var local_real_zoomoutwidth;
 var local_real_zoomoutheight;

 if ( global_integer_zoomlevel <= global_integer_zoomlevelminimum )
 {
  return;
 }

 global_integer_zoomlevel--;

 local_real_zoomoutwidth=global_integer_defaultwidth / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare;
 local_real_zoomoutheight=global_integer_defaultheight / Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare;

 global_integer_leftx=Math.round(global_integer_leftx - ( (local_real_zoomoutwidth - global_integer_zoomwidth) / 2 ));
 global_integer_topy=Math.round(global_integer_topy - ( (local_real_zoomoutheight - global_integer_zoomheight) / 2 ));

 global_integer_zoomwidth=Math.round(local_real_zoomoutwidth);
 global_integer_zoomheight=Math.round(local_real_zoomoutheight);
 global_integer_movex=Math.round(global_integer_zoomwidth * global_real_movepercentage);
 global_integer_movey=Math.round(global_integer_zoomheight * global_real_movepercentage);

 mapimage_checkx();
 mapimage_checky();
 mapimage_setsrc();
}

function mapimage_panleft()
{
 if ( global_integer_leftx == global_integer_minimumx )
 {
  return;
 }

 if ( global_integer_minimumx < global_integer_leftx )
 {
  global_integer_leftx-=global_integer_movex;
 }

 if ( global_integer_leftx < global_integer_minimumx )
 {
  global_integer_leftx=global_integer_minimumx;
 }

 mapimage_setsrc();
}

function mapimage_panright()
{
 var local_integer_maximumx;

 local_integer_maximumx=global_integer_maximumx - global_integer_zoomwidth;

 if ( global_integer_leftx == local_integer_maximumx )
 {
  return;
 }

 if ( global_integer_leftx < local_integer_maximumx )
 {
  global_integer_leftx+=global_integer_movex;
 }

 if ( local_integer_maximumx < global_integer_leftx )
 {
  global_integer_leftx=local_integer_maximumx;
 }

 mapimage_setsrc();
}

function mapimage_panup()
{
 var local_integer_maximumy;

 local_integer_maximumy=global_integer_maximumy - global_integer_zoomheight;

 if ( global_integer_topy == local_integer_maximumy )
 {
  return;
 }

 if ( global_integer_topy < local_integer_maximumy )
 {
  global_integer_topy+=global_integer_movey;
 }

 if ( local_integer_maximumy < global_integer_topy )
 {
  global_integer_topy=local_integer_maximumy;
 }

 mapimage_setsrc();
}

function mapimage_pandown()
{
 if ( global_integer_topy == global_integer_minimumy )
 {
  return;
 }

 if ( global_integer_minimumy < global_integer_topy )
 {
  global_integer_topy-=global_integer_movey;
 }

 if ( global_integer_topy < global_integer_minimumy )
 {
  global_integer_topy=global_integer_minimumy;
 }

 mapimage_setsrc();
}"




### HTML script: mapimage events ###

echo "
// ### HTML script: mapimage events ###

function mapimage_onload()
{
 global_block_zoompan=false;
 wms_hideflowframes();
}

function mapimage_onkeyup(parameter_object_event)
{
 if (global_boolean_blockpanzoom)
 {
  return;
 }

 if (event.which == 37) mapimage_panleft();
 if (event.which == 38) mapimage_panup();
 if (event.which == 39) mapimage_panright();
 if (event.which == 40) mapimage_pandown();

 if (global_boolean_blockzoom)
 {
  return;
 }

 if (event.which == 107) mapimage_zoomin();
 if (event.which == 109) mapimage_zoomout();
}


</script>"


echo "<script>

function mapimage_onwheel(object, event)
{
 var local_integer_wheeldelta;

 if (global_boolean_blockpanzoom)
 {
  return;
 }

 if (global_boolean_blockzoom)
 {
  return;
 }

 if ( event.wheelDelta )
 {
  local_integer_wheeldelta=event.wheelDelta;
 }
 else
 {
  local_integer_wheeldelta=-event.deltaY;
 }
alert(local_integer_wheeldelta);

 if ( local_integer_wheeldelta >= 0 )
 {
 if ( global_real_zoomlevelmax <= global_real_zoomlevel )
  {
   return;
  }
 }
 else
 {
 if ( global_real_zoomlevel <= global_real_zoomlevelmin )
  {
   return;
  }
 }

// var imgX = event.clientX - Math.floor(object.getBoundingClientRect().left);
// var imgY = event.clientY + document.body.scrollTop + document.documentElement.scrollTop - Math.floor(object.getBoundingClientRect().top);

// global_centerx=global_zoom_centerx + Math.floor((global_width/($CONFIG_WMS_MAPIMAGEWIDTH*global_zoom_widthrate))*(imgX-($CONFIG_WMS_MAPIMAGEWIDTH/2)));
// global_centery=global_zoom_centery - Math.floor((global_height/($CONFIG_WMS_MAPIMAGEHEIGHT*global_zoom_heightrate))*(imgY-($CONFIG_WMS_MAPIMAGEHEIGHT/2)));

// if ( local_integer_wheeldelta >= 0 )
// {
//  wms_zoomin();
// }
// else
// {
//  wms_zoomout();
// }
}

</script>"

echo "<script>
function mapimage_onmousedown(object, event)
{
 if (global_block_zoompan)
 {
  return;
 }

 wms_hideflowframes();

 global_drag_startx=event.clientX;
 global_drag_starty=event.clientY;
 global_is_dragdrop=true;

// var e = window.event;
// var local_x = e.clientX;
// var local_y = e.clientY;
// global_drag_interval=setIntreval(wms_drag_showmap, 1000);
}

</script>"

echo "<script>
function mapimage_onmouseup(object, event)
{
 if (global_block_zoompan)
 {
  return;
 }

 global_is_dragdrop=false;

 var local_deltaX=event.clientX-global_drag_startx;
 var local_deltaY=event.clientY-global_drag_starty;

 if (local_deltaX == 0 && local_deltaY == 0)
 {
  mapimage_click(object, event);
  return;
 }

 global_zoom_centerx=global_centerx-Math.floor((local_deltaX/${CONFIG_WMS_MAPIMAGEWIDTH})*(global_width/global_zoom_widthrate));
 global_zoom_centery=global_centery+Math.floor((local_deltaY/${CONFIG_WMS_MAPIMAGEHEIGHT})*(global_height/global_zoom_heightrate));

 wms_movecenter();
 wms_showmap();
}

</script>"

echo "<script>
function mapimage_onmouseleave(object, event)
{
 if (global_block_zoompan)
 {
  return;
 }

 if ( ! global_is_dragdrop )
 {
  return false;
 }

 global_is_dragdrop=false;

 var local_deltaX=event.clientX-global_drag_startx;
 var local_deltaY=event.clientY-global_drag_starty;

 global_zoom_centerx=global_centerx-Math.floor((local_deltaX/${CONFIG_WMS_MAPIMAGEWIDTH})*(global_width/global_zoom_widthrate));
 global_zoom_centery=global_centery+Math.floor((local_deltaY/${CONFIG_WMS_MAPIMAGEHEIGHT})*(global_height/global_zoom_heightrate));

 wms_movecenter();
 wms_showmap();
}

</script>"

echo "
</body>
</html>"
