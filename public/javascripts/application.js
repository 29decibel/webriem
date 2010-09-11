// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//here we bind the data picker control
$(function(){
	//wrap the datatime picker
	$(".datepicker").each(
		function(){
			$(this).datepicker();
			});
	//set the error message span to none if it have no message
	$("span.error_message").each(
		function(){
			var span=$(this);
			if(span.text()=="")
			{
				span.css("display","none");
			}
			else
			{
				span.css("display","inline-block");
			}
		}
		);
});
//here we bind the munu staff
var timeout    = 500;
var closetimer = 0;
var ddmenuitem = 0;

function jsddm_open()
{  jsddm_canceltimer();
   jsddm_close();
   ddmenuitem = $(this).find('ul').css('visibility', 'visible');}

function jsddm_close()
{  if(ddmenuitem) ddmenuitem.css('visibility', 'hidden');}

function jsddm_timer()
{  closetimer = window.setTimeout(jsddm_close, timeout);}

function jsddm_canceltimer()
{  
	if(closetimer){
		window.clearTimeout(closetimer);
		closetimer = null;}
}

$(document).ready(function()
{  $('#menu > li').bind('mouseover', jsddm_open)
   $('#menu > li').bind('mouseout',  jsddm_timer)});

document.onclick = jsddm_close;

function remove_fields(link) {
    $(link).previous("input[type=hidden]").value = "1";  
    $(link).up(".fields").hide();  
}
