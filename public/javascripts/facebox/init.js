$(function(){
	$.facebox.settings.closeImage = '/images/facebox/closelabel.png';
	$.facebox.settings.loadingImage = '/images/facebox/loading.gif';
	$("#mark_the_doc").hide();
});
//some methods that use facebox
jQuery(document).ready(function($) {
  $('a.facebox').facebox(); 
})