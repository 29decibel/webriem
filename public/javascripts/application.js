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
		//$("a.check_details").live("click",function(){
		//	//change the words
		//	if($(this).text()=="展开明细")
		//	{
		//		$(this).text("折叠明细");
		//	}			
		//	else
		//	{
		//		$(this).text("展开明细");
		//	}
		//	//expand or collapse the details
		//	$(this).closest("tr").next("tr").toggle();
		//	return false;
		//});
		//bind the fee type
		//bind_change_events();
		//fire it once
		//$("select.fee_type").change();
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
		//bind ajax event 
		$("form").live("ajax:before",function(){
			//var link_position=$("div.filter a.filter").offset();
			//$('span#spinner').css({ top: link_position.top , left: link_position.left }).fadeIn();
			//$("span#spinner").fadeIn();
			$.blockUI({ css: { 
          border: 'none', 
          padding: '15px', 
          backgroundColor: '#000', 
          '-webkit-border-radius': '10px', 
          '-moz-border-radius': '10px', 
          opacity: .5, 
          color: '#fff'
      },message:'请稍等' }); 

      //setTimeout($.unblockUI, 2000);
		});
		$("form").live("ajax:complete",function(){
			//$("span#spinner").fadeOut();
			$.unblockUI();
		});
		//bind the submit link
		$("a.submit").live("click",function(){
			$(this).closest("form").submit();
			return false;
		});
		//bind the amount and rate event
		$("input.rate").live("change",adapt_apply_amount_by_rate);
		$("input.ori_amount").live("change",adapt_apply_amount_by_rate);
		//bind all references
		//pop up reference window
		$("div.reference a").live("click",pop_up_reference_window);
		//close window and back to the input
		$("div.filter a.back_to_reference").live("click",back_to_the_reference);
});
function adapt_apply_amount_by_rate()
{
	var tr= $(this).closest("tr");
	var rate=tr.find("input.rate").val();
	var ori_amount=tr.find("input.ori_amount").val();
	tr.find("input.amount").val(rate*ori_amount);
}

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
		//find all and show it
		var children=$(this).closest("tr").next("tr").find("div.rdd_details");
		children.show();
		//hide others
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
		if(is_split==1)
		{
			//children.not("div.reim_split_details").find("table tr.fields").hide().find("td:last input").val("true");
			$("div.reim_split_details").show();		
		}
		else
		{
			$("div.reim_split_details").find("table tr.fields").hide().find("td:last input").val("true");
			$("div.reim_split_details").hide();		
		}
	});
}

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

function add_upload_files(current,path)
{
	sFeatures="dialogHeight: 300px; dialogWidth: 600px;dialogTop: 190px;dialogLeft: 220px; edge:Raised;border:thin;location:no; center: Yes;help: No; resizable: No; status: No;"
	window.showModalDialog(path,'',sFeatures);
}
function removeSelected(remove_link)
{
	$(remove_link).parent().find("select :selected").remove();
}
//=======================================pop up references...........
function pop_up_reference_window()
{
	value_now=$(this).siblings("input[type=hidden]").val() || "null";
	path="/model_search/index?bare=true&class_name="+$(this).attr('class-data')+"&values="+value_now;
	sFeatures="dialogHeight: 300px; dialogWidth: 600px;dialogTop: 190px;dialogLeft: 220px; edge:Raised;border:thin;location:no; center: Yes;help: No; resizable: No; status: No;"

	//pop up a dialog
	var returnValue=window.showModalDialog(path,'',sFeatures);
	//get the window value and set to the textbox and hiddenfield
	//set the display info
	if(returnValue)
	{
		//set displayinfo
		$(this).siblings("input[type=text]").val(returnValue.displays);
		//set the id
		$(this).siblings("input[type=hidden]").val(returnValue.ids);
	}
	return false;
}
//set the selected value the result
//close the window
function back_to_the_reference()
{
	var ids="";
	var displays="";
	$("input:checked.ref_select").each(function(){
		ids += $(this).siblings("input.hidden_id").val() + "_";
		displays += $(this).siblings("input.hidden_display").val() + ";";
	});
	//trim the ;
	if(ids.length>0)
	{
		ids=ids.substring(ids.length-1,"");
	}
	if(displays.length>0)
	{
		displays=displays.substring(displays.length-1,"");
	}
	
	//alert($("input:checked.ref_select").size());
	var returnInfo=new Object();
	returnInfo.ids=ids;
	returnInfo.displays=displays;
	//returnInfo.id=
	//$()
	//set the return value
	window.returnValue=returnInfo;
	//close the window
	window.close();
}