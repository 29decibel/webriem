// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//here we bind the data picker control
$(function(){
	//wrap the datatime picker
	$(".datepicker").datepicker();
	$(".datetimepicker").datetimepicker();
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
		//bind the is_split change events
		bind_is_split_change_events();
		//fire it once
		$("select.is_split_reim").change();
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
		//control the reference window's check box
		$("#selected_all").live("change",function(){
			$(".ref_select").attr("checked",$(this).is(':checked'));
		});
		//register the ref select change events
		$("input.ref_select").live("change",function(){
			//select one only
			if($("#selected_all").size()==0)
			{
				$(".ref_select").not($(this)).attr("checked",false);
			}
		});
		//for the damn ie
		if($.browser.msie)
		{
			$('input.ref_select,#selected_all').live('click', function(){
				alert("sb");
		    	$(this).trigger('change');
			});
		}

		//observe the region type select 
		$(".region_type_select").live("change",function(){
			region_type= $(this).val();
			//alert(region_type);
			//set neib region id info
			$(this).closest("tr").find("input#region_info").next("a").attr("pre_condition","region_type_id="+region_type);
		});
		//observe the region change so to calculate the fee standard
		$("input.get_fee,.region_type_select").live("change",function(){
			//get the duty id 
			var duty_id=$("#duty_for_fee_standard").val();
			//var region_id=$(this).siblings("input.ref_hidden_field").val();
			var region_type_id=$(this).closest("tr").find(".region_type_select").val();
			var fee_code=$(this).closest("tr").attr("fee_code");
			//person type
			var pt=$("#pt_for_fee_standard").val();
			//this can be a very good find stuff pattern
			//when you want to find something another cell
			//first go up until find the table row and then find stuff you want within it 
			var fee_standard_control=$(this).closest("tr").find("input.fee_standard");
			//make a ajax call and get the fee
			$.ajax({
			  type: "GET",
			  url: "/ajax_service/getfee",
			  data: "region_type_id="+region_type_id+"&duty_id="+duty_id+"&fee_code="+fee_code+"&pt="+pt,
			  beforeSend: function(){
					fee_standard_control.val("正在获取...");
			  },
			  success: function(msg){
					var values=msg.split(",");
					//set fees
			    fee_standard_control.val(values[0]);
					fee_standard_control.change();
					//set currency					
					fee_standard_control.closest("tr").find("input#currency_info").val(values[2]);
					fee_standard_control.closest("tr").find("input#currency_info").prev().val(values[1]);
					fee_standard_control.closest("tr").find(".doc_rate").val(values[3]);
			  },
				error: function(){
					fee_standard_control.val("暂无*");
				}
			});
		});
		//observe the time and get the extra work time fee
		$(".is_sunday,.ew_b_time,.ew_e_time").live("change",function(){
			var is_sunday=$(this).closest("tr").find(".is_sunday").val()==0;
			var start_time=$(this).closest("tr").find(".ew_b_time").val();
			var end_time=$(this).closest("tr").find(".ew_e_time").val();
			var fee_code=$(this).closest("tr").attr("fee_code");
			var extra_st_control=$(this).closest("tr").find(".extra_st");
			if(start_time!="" && end_time!="")
			{
				//make a ajax call and get the fee
				$.ajax({
				  type: "GET",
				  url: "/ajax_service/get_extrafee",
				  data: "is_sunday="+is_sunday+"&start_time="+start_time+"&end_time="+end_time+"&fee_code="+fee_code,
				  beforeSend: function(){
						extra_st_control.val("正在获取...");
				  },
				  success: function(msg){
						//set fees
						extra_st_control.val(msg);
						extra_st_control.closest("tr").find("input.doc_ori_amount").val(msg);
						extra_st_control.closest("tr").find("input.doc_ori_amount").change();
				  },
					error: function(){
						extra_st_control.val("暂无*");
					}
				});
			}
		});
		//fire the region type change
		$(".region_type_select").change();
		//fire the region change event
		$("input.get_fee").change();
		//set reference readonly
		$("input.ref").attr("readonly",true);
		//set the fee standard readonly
		$("input.fee_standard").attr("readonly",true);
		//always set the approvers not display
		$("#approvers").css("display","none");
		//always set the approve info form not display
		$("#approve_info").css("display","none");
		//for the work flow page
		$("select.is_self_dep").live("change",function(){
			if($(this).val()==0)
			{
				$(this).closest("tr").find("div.dep input").removeAttr("disabled");
				$(this).closest("tr").find("div.dep a").show();
			}
			else
			{
				$(this).closest("tr").find("div.dep input").val("");
				$(this).closest("tr").find("div.dep input").attr("readonly","true");
				$(this).closest("tr").find("div.dep a").hide();
			}
		});
		$("select.is_self_dep").change();

});

function adapt_apply_amount_by_rate()
{
	var tr= $(this).closest("tr");
	var rate=tr.find("input.rate").val();
	var ori_amount=tr.find("input.ori_amount").val();
	tr.find("input.amount").val(rate*ori_amount);
}

//bind the change events
function bind_is_split_change_events()
{
	$("select.is_split_reim").change(function(){
		//alert($(this).children("option:selected").text());
		//$(this).parent
		is_split=$("select.is_split_reim").children("option:selected").val();
		if(is_split==1)
		{
			//children.not("div.reim_split_details").find("table tr.fields").hide().find("td:last input").val("true");
			$("div.is_split_reim").show("slow");		
		}
		else
		{
			$("div.is_split_reim").find("table tr.fields").hide().find("td:last input").val("true");
			$("div.is_split_reim").hide("slow");		
		}
		//set the doc head's project readonly 
		if($(this).val()==0)
		{
			$(this).closest("div.form_block").find("div.project input").removeAttr("disabled");
			$(this).closest("div.form_block").find("div.project a").show();
		}
		else
		{
			$(this).closest("div.form_block").find("div.project input").val("");
			$(this).closest("div.form_block").find("div.project input").attr("readonly","true");
			$(this).closest("div.form_block").find("div.project a").hide();
		}
	});
}

function remove_fields(link) {
    $(link).prev("input[type=hidden]").val("true");  
    $(link).closest("tr.fields").hide(); 
	set_unique_sequence_num($(link).closest("table.form_input").find("input.table_row_sequence").not('input[value=true]'));
	//invoke the calcalate number
	$("input.doc_ori_amount,input.doc_rate,input.doc_HR_amount,input.doc_FI_amount").change();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().parent().before(content.replace(regexp, new_id));
//debugger
	set_unique_sequence_num($(link).closest("table.form_input").find("input.table_row_sequence").not('input[value=true]'));
	//wrap the datatime picker
	$(".datepicker").datepicker();
	$(".datetimepicker").datetimepicker();
	//set the doc state
	set_form_state();
	//set reference readonly
	$("input.ref").attr("readonly",true);
	//set the fee standard readonly
	$(link).closest("tr").prev().find("input.fee_standard").attr("readonly",true);
	//fire get fee
	$(link).closest("tr").prev().find(".region_type_select").change();
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
	set_form_state();
	return false;
}
//=================================select the approver when in the workflow someone begin apply approve
function select_approver_or_begin_work_flow()
{
	if($('#approvers').size()==0)
	{
		make_bwf_request(-1);
	}
	else
	{
		//decide whether should choose a person to 
		$.blockUI({ message: $('#approvers') });
	}

}
function begin_work_flow(link)
{
	approver_id=$("input:checked.ref_select").siblings("#approver").val();
	make_bwf_request(approver_id);
}

//make a ajax request to begin the work flow
function make_bwf_request(approver_id)
{
	if(approver_id)
	{
		$.ajax({
		  type: "GET",
		  url: "/doc_heads/begin_work",
		  data: "doc_id="+$("#doc_id").val()+"&approver_id="+approver_id,
		  beforeSend: function(){
				//fee_standard_control.val("正在获取...");
		  },
		  success: function(msg){
		    //fee_standard_control.val(msg);
		  },
			error: function(){
				//fee_standard_control.val("暂无*");
			}
		});
	}
	$.unblockUI();
}
//=======================================pop up references...........
function pop_up_reference_window()
{
	value_now=$(this).siblings("input[type=hidden]").val() || "null";
	path="/model_search/index?checkable=true&ref=true&confirmable=true&class_name="+$(this).attr('class-data')+"&values="+value_now;
	if($(this).attr('multicheck'))
	{
		path+="&multicheck="+$(this).attr('multicheck');
	}
	if($(this).attr('pre_condition'))
	{
		path+="&pre_condition="+$(this).attr('pre_condition');
	}
	//能否在录入所有单据 参照选择“费用类型”档案时，不允许选择非末级费用类型。
	if($(this).attr('class-data')=="Fee" && $(this).attr("self")!="true")
	{
		path+="&pre_condition=Length(code)>2";
	}
	sFeatures="dialogHeight: 300px; dialogWidth: 600px;dialogTop: 190px;dialogLeft: 220px; edge:Raised;border:thin;location:no; center: Yes;help: No; resizable: No; status: No;"

	//pop up a dialog
	var returnValue=window.showModalDialog(path,'',sFeatures);
	//get the window value and set to the textbox and hiddenfield
	//set the display info
	if(returnValue)
	{
		//set displayinfo
		$(this).siblings(".ref").val(returnValue.displays);
		//set the id
		$(this).siblings(".ref_hidden_field").val(returnValue.ids);
		//fire the change event so now you can get the fee standard
		$(this).siblings(".ref").change();
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
function batch_pay()
{
	if($("input:checked.ref_select").size()!=0)
	{
		//get all doc id and invoke a ajax call
		var doc_ids="";
		$("input:checked.ref_select").each(function(){
			doc_ids += $(this).siblings("input.hidden_id").val() + "_";
		});
		$.ajax({
		  type: "GET",
		  url: "/doc_heads/batch_pay",
		  data: "doc_ids="+doc_ids,
		  beforeSend: function(){
				//fee_standard_control.val("正在获取...");
				$.blockUI({ message:"付款中，请稍后..." }); 
		  },
		  success: function(msg){
		    //fee_standard_control.val(msg);
				$("a.filter").submit();
				$.unblockUI(); 
		  },
			error: function(){
				//fee_standard_control.val("暂无*");
				$("a.filter").submit();
				$.unblockUI();
			}
		});	
	}
}
function batch_approve()
{
	if($("input:checked.ref_select").size()!=0)
	{
		//clear previsou value
		$("#is_ok").attr("checked",false);
		$("#comments").val("");
		$.blockUI({ message: $('#approve_info') });
	}
}
function batch_approve_confirm()
{
	//get all doc id and invoke a ajax call
	var doc_ids="";
	$("input:checked.ref_select").each(function(){
		doc_ids += $(this).siblings("input.hidden_id").val() + "_";
	});
	var is_ok=$("#is_ok").is(':checked');
	var comments=$("#comments").val();
	//make a ajax call
	$.ajax({
	  type: "GET",
	  url: "/doc_heads/batch_approve",
	  data: "doc_ids="+doc_ids+"&is_ok="+is_ok+"&comments="+comments,
	  beforeSend: function(){
			//fee_standard_control.val("正在获取...");
			$.blockUI({ message:"审批中，请稍后..." }); 
	  },
	  success: function(msg){
	    //fee_standard_control.val(msg);
			$("a.filter").submit();
			$.unblockUI();
	  },
		error: function(){
			//fee_standard_control.val("暂无*");
			$("a.filter").submit();
			$.unblockUI();
		}
	});
	
}