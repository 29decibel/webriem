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
		//bind the check details event
		$("a.check_details").live("click",function(){
			//change the words
			if($(this).text()=="展开明细")
			{
				$(this).text("折叠明细");
			}			
			else
			{
				$(this).text("展开明细");
			}
			//expand or collapse the details
			$(this).closest("tr").next("tr").toggle();
			return false;
		});
		//bind the fee type
		bind_change_events();
		//fire it once
		$("select.fee_type").change();
		//change the enter key to tab
		$('input').live("keypress", function(e) {
		                /* ENTER PRESSED*/
		                if (e.keyCode == 13) {
		                    /* FOCUS ELEMENT */
		                    var inputs = $(this).parents("form").eq(0).find(":input,:select");
		                    var idx = inputs.index(this);

		                    if (idx == inputs.length - 1) {
		                        inputs[0].select()
		                    } else {
		                        inputs[idx + 1].focus(); //  handles submit buttons
		                        inputs[idx + 1].select();
		                    }
		                    return false;
		                }
		            });
		//bind the submit link
		$("a.submit").live("click",function(){
			$(this).closest("form").submit();
			return false;
		});
});

//bind the change events
function bind_change_events()
{
	$("select.fee_type,select.is_split_reim").change(function(){
		//alert($(this).children("option:selected").text());
		//$(this).parent
		var fee_type;
		var is_split;
		if($(this).attr("class")=="basic_input fee_type")
		{
			fee_type=$(this).children("option:selected").text();
			is_split=$(this).closest("tr").find("select.is_split_reim").children("option:selected").val();
		}
		else
		{
			is_split=$(this).children("option:selected").val();
			fee_type=$(this).closest("tr").find("select.fee_type").children("option:selected").text();			
		}
		//var fee_type=$(this).closest("select.fee_type").children("option:selected").text();
		//var is_split=$(this).closest("select.is_split_reim").children("option:selected").text();
		//alert(fee_type);
		//alert(is_split);
		//var selected_text=$(this).children("option:selected").text();
		var children=$(this).closest("tr").next("tr").find("div.rdd_details");
		children.show();
		//children.find("table tr.fields td:last input").val("false");
		//here is the delete operation
		//children.find("table tr.fields").hide().find("td:last input").val("true");
		if(is_split==1)
		{
			children.not("div.reim_split_details").find("table tr.fields").hide().find("td:last input").val("true");
			children.not("div.reim_split_details").hide().end();
		}
		else
		{
			switch(fee_type)
			{				
				case "差旅费":
					children.not("div.rd_travel").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_travel").hide().end();				
					break;
				case "交通费":
					children.not("div.rd_transport").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_transport").hide().end();				
					break;
				case "住宿费":
					children.not("div.rd_loding").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_loding").hide().end();
					break;
				case "工作餐费":
					children.not("div.rd_work_meal").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_work_meal").hide().end();
					break;
				case "加班餐费":
					children.not("div.rd_extra_work_meal").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_extra_work_meal").hide().end();				
					break;
				case "加班交通费":
					children.not("div.rd_extra_work_car").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_extra_work_car").hide().end();				
					break;
				case "业务交通费":
					children.not("div.rd_common_transport").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_common_transport").hide().end();				
					break;
				case "福利费用":
					children.not("div.rd_benefit").find("table tr.fields").hide().find("td:last input").val("true");
					children.not("div.rd_benefit").hide().end();				
					break;
				default:
					children.find("table tr.fields").hide().find("td:last input").val("true");
					children.hide();
			}
		}		
	});
}

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
	//bind the change events
	bind_change_events();
	$("select.fee_type").change();
}
//找到所有的table,只要他有sequence列,set the number to a sequence number
function set_unique_sequence_num(sequences){
	//设置他们的序号
	sequences.each(function(index,ele){
		$(this).val(index+1);
		//fire it once
		$(this).attr("readonly","readonly");
	});
}