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
<body tabindex='-1' onclick='parent.popupiframes_hide();'>
"

### HTML tags: mapimage, map help and map legend ###

echo "
<!-- HTML tags: mapimage, map help and map legend -->

<img tabindex='0' id='mapimage' draggable='false'
 width='100%' height='$CONFIG_WMS_IMAGEHEIGHT'
 style='display: block; margin: 0 auto; padding: 0; user-select: none; -webkit-user-select: none; -moz-user-select: none; -ms-user-select: none;'
 onload='mapimage_onload();' onkeydown='return mapimage_onkeydown(event);' onkeyup='return mapimage_onkeyup(event);'
 ondragstart='return false;' onwheel='mapimage_onwheel(event); return false;'
 onmousedown='mapimage_onmousedown(event);' onmousemove='mapimage_onmousemove(event);' onmouseup='mapimage_onmouseup(event);' onmouseleave='mapimage_onmouseleave(event);'
 ><br>

<span class='map-help'>$CONFIG_MAP_HELPHTML</span>
<span class='map-legend'>$CONFIG_MAP_LEGENDHTML</span>"

### HTML script ###

echo "
<!-- HTML script -->
<script>"

### HTML script: set variables from config ###

echo "
// ### HTML script: set variables from config ###

document.getElementById('mapimage').addEventListener('wheel', function(){
 mapimage_onwheel(this, event);
 event.preventDefault();
});

var global_integer_minimumx=$CONFIG_WMS_MINIMUMX;
var global_integer_maximumx=$CONFIG_WMS_MAXIMUMX;
var global_integer_minimumy=$CONFIG_WMS_MINIMUMY;
var global_integer_maximumy=$CONFIG_WMS_MAXIMUMY;

var global_integer_centerx=$CONFIG_WMS_DEFAULTCENTERX;
var global_integer_centery=$CONFIG_WMS_DEFAULTCENTERY;

var global_integer_zoomlevel=$CONFIG_WMS_DEFAULTZOOMLEVEL;
var global_integer_zoomlevelminimum=$CONFIG_WMS_ZOOMLEVELMINIMUM;
var global_integer_zoomlevelmaximum=$CONFIG_WMS_ZOOMLEVELMAXIMUM;

var global_integer_imagemaximumwidth=$CONFIG_WMS_IMAGEMAXIMUMWIDTH;
var global_integer_imagefullwidth=$CONFIG_WMS_IMAGEFULLWIDTH;

if (document.getElementById('mapimage').width < global_integer_imagefullwidth)
{
 global_integer_imagefullwidth=document.getElementById('mapimage').width;
}"

### HTML script: set variables from HTML GET ###

echo "
// ### HTML script: set variables from HTML GET ###

var global_integer_leftx;
var global_integer_bottomy;"

### HTML script: calculate variables ###

echo "
// ### HTML script: calculate variables ###

var global_integer_maximumwidth=global_integer_maximumx - global_integer_minimumx;
var global_integer_maximumheight=global_integer_maximumy - global_integer_minimumy;
var global_integer_fullwidth=Math.round((global_integer_imagefullwidth / global_integer_imagemaximumwidth) * global_integer_maximumwidth);

var global_real_zoomlevelstepsquare=Math.pow($CONFIG_WMS_ZOOMLEVELSTEP, 2);
var global_real_movepercentage=$CONFIG_WMS_MOVEPERCENTAGE/100;"

### HTML script: other variables ###

echo "
// ### HTML script: other variables ###

var global_boolean_blockpanzoom=false;
var global_boolean_blockzoom=false;
var global_boolean_clicking=false;
var global_boolean_panning=false;

var global_boolean_doresize=false;

var global_integer_imagewidth;

var global_integer_zoomwidth;
var global_integer_zoomheight;

var global_integer_movex;
var global_integer_movey;
var global_integer_movemaximumx;
var global_integer_movemaximumy;

var global_interval_panning;

var global_integer_panningstartx;
var global_integer_panningstarty;
var global_integer_panningx;
var global_integer_panningy;"

### HTML script: set other variables ###

echo "
// ### HTML script: set other variables ###

//var global_drag_interval;"

### HTML script: calculate zoom and show mapimage ###

echo "
// ### HTML script: calculate zoom and show mapimage ###

mapimage_calculatehorizontal();
mapimage_calculatevertical();

mapimage_calculatemove();

global_boolean_doresize=true;
mapimage_setsrc();

function mapimage_setcoordinates(parameter_integer_centerx, parameter_integer_centery, parameter_integer_width, parameter_integer_height)
{
 alert(parameter_integer_centerx + ':' + parameter_integer_centery + ':' + parameter_integer_width + ':' + parameter_integer_height);

 global_integer_centerx=parameter_integer_centerx;
 global_integer_centery=parameter_integer_centery;

 global_integer_zoomlevel=10;

 mapimage_calculatehorizontal();
 mapimage_calculatevertical();

 mapimage_calculatemove();

 global_boolean_doresize=true;
 mapimage_setsrc();
}

function mapimage_checkx()
{
 var local_integer_maximumx;

 if (global_integer_zoomwidth > global_integer_maximumwidth)
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

 if (global_integer_zoomheight > global_integer_maximumheight)
 {
  return;
 }

 if ( global_integer_bottomy < global_integer_minimumy )
 {
  global_integer_bottomy=global_integer_minimumy;
  return;
 }

 local_integer_maximumy=global_integer_maximumy - global_integer_zoomheight;

 if ( local_integer_maximumy < global_integer_bottomy )
 {
  global_integer_bottomy=local_integer_maximumy;
  return;
 }
}

function mapimage_calculatehorizontal()
{
 var local_integer_imagemaximumwidth;
 var local_integer_maximumzoomwidth;
 var local_integer_zoomwidth;

 local_integer_imagemaximumwidth=Math.round(global_integer_imagemaximumwidth * Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare);

 if ( local_integer_imagemaximumwidth <= global_integer_imagefullwidth )
 {
  global_integer_imagewidth=local_integer_imagemaximumwidth;
  global_integer_zoomwidth=global_integer_maximumwidth;
  global_integer_leftx=global_integer_minimumx;

  return;
 }

 local_integer_maximumzoomwidth=Math.round(global_integer_maximumwidth / (Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare));

 global_integer_imagewidth=global_integer_imagefullwidth;
 global_integer_zoomwidth=Math.round((global_integer_imagewidth / global_integer_imagemaximumwidth) * local_integer_maximumzoomwidth);
 global_integer_leftx=Math.round(global_integer_centerx - (global_integer_zoomwidth / 2));
}

function mapimage_calculatevertical()
{
 global_integer_zoomheight=Math.round(global_integer_maximumheight / (Math.pow(global_integer_zoomlevel, 2) * global_real_zoomlevelstepsquare));
 global_integer_bottomy=Math.round(global_integer_centery - (global_integer_zoomheight / 2));
}

function mapimage_calculatemove()
{
 global_integer_movex=Math.round(global_integer_zoomwidth * global_real_movepercentage);
 global_integer_movey=Math.round(global_integer_zoomheight * global_real_movepercentage);
 global_integer_movemaximumx=global_integer_maximumx - global_integer_zoomwidth;
 global_integer_movemaximumy=global_integer_maximumy - global_integer_zoomheight;
}

function mapimage_calculatecoordinate(parameter_integer_x, parameter_integer_y)
{
 var local_real_ratiox;
 var local_real_ratioy;

 local_real_ratiox=parameter_integer_x / document.getElementById('mapimage').width;
 local_real_ratioy=(document.getElementById('mapimage').height - parameter_integer_y) / document.getElementById('mapimage').height;

 global_integer_centerx=global_integer_leftx + Math.round(local_real_ratiox * global_integer_zoomwidth);
 global_integer_centery=global_integer_bottomy + Math.round(local_real_ratioy * global_integer_zoomheight);
}

function mapimage_resize()
{
 document.getElementById('mapimage').style.width=global_integer_imagewidth;
 document.getElementById('mapimage').style.margin='0 auto';
}

function mapimage_click(parameter_integer_x, parameter_integer_y)
{
 var local_integer_x;
 var local_integer_y;

 parent.iframe_maptip_setposition(parameter_integer_x, parameter_integer_y);

 local_integer_x=parameter_integer_x - document.getElementById('mapimage').x;
 local_integer_y=parameter_integer_y - document.getElementById('mapimage').y;

 parent.iframe_maptip_setsrc(global_integer_imagewidth, global_integer_zoomlevel, global_integer_leftx, global_integer_bottomy, local_integer_x, local_integer_y)
}

function mapimage_setsrc()
{
 global_boolean_blockpanzoom=true;

 parent.popupiframes_hide();
//alert('$GLOBAL_URL?module=mapimage&mapimagewidth=' + global_integer_imagewidth + '&zoomlevel=' + global_integer_zoomlevel + '&leftx=' + global_integer_leftx + '&bottomy=' + global_integer_bottomy);
 document.getElementById('mapimage').src='$GLOBAL_URL?module=mapimage&mapimagewidth=' + global_integer_imagewidth + '&zoomlevel=' + global_integer_zoomlevel + '&leftx=' + global_integer_leftx + '&bottomy=' + global_integer_bottomy;
}"

### HTML script: mapimage pan & zoom ###

echo "
// ### HTML script: mapimage pan & zoom ###

function mapimage_zoomin()
{
 if ( global_integer_zoomlevelmaximum <= global_integer_zoomlevel )
 {
  return;
 }

 global_integer_centerx=Math.round(global_integer_leftx + (global_integer_zoomwidth / 2));
 global_integer_centery=Math.round(global_integer_bottomy + (global_integer_zoomheight / 2));

 global_integer_zoomlevel++;

 mapimage_calculatehorizontal();
 mapimage_calculatevertical();
 mapimage_calculatemove();

 global_boolean_doresize=true;
 mapimage_setsrc();
}

function mapimage_zoomincoordinate(parameter_integer_x, parameter_integer_y)
{
 if ( global_integer_zoomlevelmaximum <= global_integer_zoomlevel )
 {
  return;
 }

 mapimage_calculatecoordinate(parameter_integer_x, parameter_integer_y);

 global_integer_zoomlevel++;

 mapimage_calculatehorizontal();
 mapimage_calculatevertical();
 mapimage_calculatemove();

 mapimage_checkx();
 mapimage_checky();

 global_boolean_doresize=true;
 mapimage_setsrc();
}

function mapimage_zoomout()
{
 if ( global_integer_zoomlevel <= global_integer_zoomlevelminimum )
 {
  return;
 }

 global_integer_centerx=Math.round(global_integer_leftx + (global_integer_zoomwidth / 2));
 global_integer_centery=Math.round(global_integer_bottomy + (global_integer_zoomheight / 2));

 global_integer_zoomlevel--;

 mapimage_calculatehorizontal();
 mapimage_calculatevertical();
 mapimage_calculatemove();

 mapimage_checkx();
 mapimage_checky();

 global_boolean_doresize=true;
 mapimage_setsrc();
}

function mapimage_panleft()
{
 if ( global_integer_leftx == global_integer_minimumx )
 {
  return;
 }

 mapimage_pandelta(-global_integer_movex, 0);

 mapimage_setsrc();
}

function mapimage_panright()
{
 if ( global_integer_leftx == global_integer_movemaximumx )
 {
  return;
 }

 mapimage_pandelta(global_integer_movex, 0);

 mapimage_setsrc();
}

function mapimage_panup()
{
 if ( global_integer_bottomy == global_integer_movemaximumy )
 {
  return;
 }

 mapimage_pandelta(0, global_integer_movey);

 mapimage_setsrc();
}

function mapimage_pandown()
{
 if ( global_integer_bottomy == global_integer_minimumy )
 {
  return;
 }

 mapimage_pandelta(0, -global_integer_movey);

 mapimage_setsrc();
}

function mapimage_pandelta(parameter_integer_deltax, parameter_integer_deltay)
{
 if (parameter_integer_deltax < 0)
 {
  if ( global_integer_minimumx < global_integer_leftx )
  {
   global_integer_leftx+=parameter_integer_deltax;
  }

  if ( global_integer_leftx < global_integer_minimumx )
  {
   global_integer_leftx=global_integer_minimumx;
  }
 }

 if (0 < parameter_integer_deltax)
 {
  if ( global_integer_leftx < global_integer_movemaximumx )
  {
   global_integer_leftx+=parameter_integer_deltax;
  }

  if ( global_integer_movemaximumx < global_integer_leftx )
  {
   global_integer_leftx=global_integer_movemaximumx;
  }
 }

 if (parameter_integer_deltay < 0)
 {
  if ( global_integer_minimumy < global_integer_bottomy )
  {
   global_integer_bottomy+=parameter_integer_deltay;
  }

  if ( global_integer_bottomy < global_integer_minimumy )
  {
   global_integer_bottomy=global_integer_minimumy;
  }
 }

 if (0 < parameter_integer_deltay)
 {

  if ( global_integer_bottomy < global_integer_movemaximumy )
  {
   global_integer_bottomy+=parameter_integer_deltay;
  }

  if ( global_integer_movemaximumy < global_integer_bottomy )
  {
   global_integer_bottomy=global_integer_movemaximumy;
  }
 }
}

function mapimage_panning()
{
 var local_integer_deltax;
 var local_integer_deltay;

 if (global_integer_panningstartx == global_integer_panningx && global_integer_panningstarty == global_integer_panningy)
 {
  return;
 }

 clearInterval(global_interval_panning);

 local_integer_deltax=global_integer_panningx - global_integer_panningstartx;
 local_integer_deltay=global_integer_panningy - global_integer_panningstarty;

 global_integer_panningstartx=global_integer_panningx;
 global_integer_panningstarty=global_integer_panningy;

 local_integer_movex=Math.round((local_integer_deltax / document.getElementById('mapimage').width) * global_integer_zoomwidth);
 local_integer_movey=Math.round((local_integer_deltay / document.getElementById('mapimage').height) * global_integer_zoomheight);

 mapimage_pandelta(-local_integer_movex, local_integer_movey);

 mapimage_checkx();
 mapimage_checky();

 mapimage_setsrc();
}"

### HTML script: mapimage events ###

echo "
// ### HTML script: mapimage events ###

function mapimage_onload()
{
 global_boolean_blockpanzoom=false;

 if (global_boolean_doresize)
 {
  mapimage_resize();
 }

 if (global_boolean_panning)
 {
  global_interval_panning=setInterval(mapimage_panning, $CONFIG_WMS_PANINTERVAL);
 }

 parent.popupiframes_hide();
}

function mapimage_onkeydown(parameter_object_event)
{
 if (parameter_object_event.which == 37) return false;
 if (parameter_object_event.which == 38) return false;
 if (parameter_object_event.which == 39) return false;
 if (parameter_object_event.which == 40) return false;
 if (parameter_object_event.which == 107) return false;
 if (parameter_object_event.which == 109) return false;

 return true;
}

function mapimage_onkeyup(parameter_object_event)
{
 if (global_boolean_blockpanzoom)
 {
  return true;
 }

 if (parameter_object_event.which == 37) { mapimage_panleft(); return false; }
 if (parameter_object_event.which == 38) { mapimage_panup(); return false; }
 if (parameter_object_event.which == 39) { mapimage_panright(); return false; }
 if (parameter_object_event.which == 40) { mapimage_pandown(); return false; }

 if (global_boolean_blockzoom)
 {
  return true;
 }

 if (parameter_object_event.which == 107) { mapimage_zoomin(); return false; }
 if (parameter_object_event.which == 109) { mapimage_zoomout(); return false; }

 return true;
}

function mapimage_onwheel(parameter_object_event)
{
 var local_integer_wheeldelta;
 var local_integer_x;
 var local_integer_y;

 document.getElementById('mapimage').focus();

 if (global_boolean_blockpanzoom)
 {
  return;
 }

 if (global_boolean_blockzoom)
 {
  return;
 }

 if ( parameter_object_event.wheelDelta )
 {
  local_integer_wheeldelta=parameter_object_event.wheelDelta;
 }
 else
 {
  local_integer_wheeldelta=-parameter_object_event.deltaY;
 }

 if ( local_integer_wheeldelta >= 0 )
 {
  local_integer_x=parameter_object_event.clientX - document.getElementById('mapimage').x;
  local_integer_y=parameter_object_event.clientY - document.getElementById('mapimage').y;

  mapimage_zoomincoordinate(local_integer_x, local_integer_y);
 }
 else
 {
  mapimage_zoomout();
 }
}

function mapimage_onmousedown(parameter_object_event)
{
 if (global_boolean_blockpanzoom)
 {
  return;
 }

 parent.popupiframes_hide();

 global_integer_panningstartx=parameter_object_event.clientX;
 global_integer_panningstarty=parameter_object_event.clientY;

 global_boolean_clicking=true;
 global_boolean_blockzoom=true;

 global_interval_panning=setInterval(mapimage_panning, $CONFIG_WMS_PANINTERVAL);
}

function mapimage_onmousemove(parameter_object_event)
{
 if (!global_boolean_clicking)
 {
  return;
 }

 global_boolean_panning=true;

 global_integer_panningx=parameter_object_event.clientX;
 global_integer_panningy=parameter_object_event.clientY;
}

function mapimage_onmouseup(parameter_object_event)
{
 if (!global_boolean_clicking)
 {
  return;
 }

 clearInterval(global_interval_panning);

 global_boolean_clicking=false;
 global_boolean_blockzoom=false;

 if (global_boolean_panning)
 {
  global_boolean_panning=false;

  global_integer_panningx=parameter_object_event.clientX;
  global_integer_panningy=parameter_object_event.clientY;

  mapimage_panning();
 }
 else
 {
  mapimage_click(parameter_object_event.clientX, parameter_object_event.clientY);
 }
}

function mapimage_onmouseleave(parameter_object_event)
{
 if (!global_boolean_panning)
 {
  return;
 }

 clearInterval(global_interval_panning);

 global_boolean_clicking=false;
 global_boolean_panning=false;
 global_boolean_blockzoom=false;

 global_integer_panningx=parameter_object_event.clientX;
 global_integer_panningy=parameter_object_event.clientY;

 mapimage_panning();
}

</script>"

echo "
</body>
</html>"
