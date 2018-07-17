#!/bin/bash

echo "<span class='search-label'>${CONFIG_SEARCH_LABEL}</span>
 <input tabindex='0' type='text' id='search_searchbox' placeholder='${CONFIG_SEARCH_PLACEHOLDER}' class='search-searchbox' onkeyup='search_searchbox_onkeyup(event);'>
 <button class='search-button' onclick='search_button_onclick();'>$CONFIG_SEARCH_BUTTONTEXT</button><br>
 <span class='search-help'>${CONFIG_SEARCH_HELP}</span>"

echo "<script>

 function search_button_onclick()
 {
  var search_rect=document.getElementById('search_searchbox').getBoundingClientRect();
  var search_text=document.getElementById('search_searchbox').value.trim();
  var search_length=search_text.length;

  searchresult_container_onload_enabled=true;
  document.getElementById('searchresult_container').style.width=0;
  document.getElementById('searchresult_container').style.height=0;
  document.getElementById('searchresult_container').style.left=search_rect.left;
  document.getElementById('searchresult_container').style.top=search_rect.bottom;
  document.getElementById('searchresult_container').style.visibility='hidden';

  if (search_length < 4)
  {
   return;
  }

  if (30 < search_length)
  {
   return;
  }

  document.getElementById('searchresult_container').src='${GLOBAL_URL}?type=searchresult&searchtext=' + search_text;
 }

 function search_searchbox_onkeyup(event)
 {
  search_button_onclick();
 }

</script>"
