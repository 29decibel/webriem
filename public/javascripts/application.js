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
		//$("input.table_row_sequence").attr("readonly","readonly");
		//set all sequence stuff readonly
		$("table.form_input").each(function(){
			set_unique_sequence_num($(this).find("input.table_row_sequence").not("input[value=true]"));
		});
});
//=======================here we bind the munu staff===================================
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
//===================================================================================
function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("true");  
    $(link).closest("tr.fields").hide(); 
		set_unique_sequence_num($(link).closest("table.form_input").find("input.table_row_sequence").not('input[value=true]'));
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().parent().before(content.replace(regexp, new_id));
//debugger
	set_unique_sequence_num($(link).closest("table.form_input").find("input.table_row_sequence").not('input[value=true]'));
	//wrap the datatime picker
	$(".datepicker").each(
		function(){
			$(this).datepicker();
			});
}
//找到所有的table,只要他有sequence列,set the number to a sequence number
function set_unique_sequence_num(sequences){
	//设置他们的序号
	sequences.each(function(index,ele){
		$(this).val(index);
		$(this).attr("readonly","readonly");
	});
}