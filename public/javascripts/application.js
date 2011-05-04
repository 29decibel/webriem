// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function init_control()
{
  //wrap the datatime picker
	$(".datepicker").datepicker();
	$(".datetimepicker").datetimepicker();
  //fire it once
  $("select.is_split_reim").change();
}
//here we bind the data picker control
$(function(){
  init_control();	

  //bind the is_split change events
  bind_is_split_change_events();

  //bind ajax event 
  $("form").live("ajax:beforeSend",function(){
    var offset_amounts=$(this).find("input.offset_amount");
    if(offset_amounts.size()>0)
    {
        var total=0.0;
        offset_amounts.each(function(){
          total+=$(this).val();
        });
        if(total==0.0)
        {
          if(!confirm("您有未进行冲抵的记录，是否继续保存？"))
          { 
            return false;
          }
        }
    }
    wait();
  });
  $("a").live("ajax:beforeSend",function(){
    wait();
  });
  $("form,a").live("ajax:complete",function(){
    $.unblockUI();
    init_control();	
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
        $(this).trigger('change');
    });
  }

  //observe the region type select 
  $(".region_type_select").live("change",function(){
    region_type= $(this).val();
    //alert(region_type);
    //set neib region id info
    $(this).closest("fieldset").find("input#region_info").next("a").attr("pre_condition","region_type_id="+region_type);
  });
  //observe the region change so to calculate the fee standard
  $("input.get_fee,.region_type_select").live("change",function(){
    //get the duty id 
    var duty_id=$("#duty_for_fee_standard").val();
    //var region_id=$(this).siblings("input.ref_hidden_field").val();
    var region_type_id=$(this).closest("fieldset").find(".region_type_select").val();
    var fee_code=$(this).closest("fieldset").attr("fee_code");
    //person type
    var pt=$("#pt_for_fee_standard").val();
    //this can be a very good find stuff pattern
    //when you want to find something another cell
    //first go up until find the table row and then find stuff you want within it 
    var fee_standard_control=$(this).closest("fieldset").find("input.fee_standard");
    //make a ajax call and get the fee[ not all the time ]
    //if($("#form_state"))
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
        fee_standard_control.closest("fieldset").find("input#currency_info").val(values[2]);
        fee_standard_control.closest("fieldset").find("input#currency_info").prev().val(values[1]);
        fee_standard_control.closest("fieldset").find(".doc_rate").val(values[3]);
      },
      error: function(){
        fee_standard_control.val("暂无*");
      }
    });
  });
  //observe the time and get the extra work time fee
  $(".is_sunday,.ew_b_time,.ew_e_time").live("change",function(){
    var is_sunday=$(this).closest("fieldset").find(".is_sunday").val()==0;
    var start_time=$(this).closest("fieldset").find(".ew_b_time").val();
    var end_time=$(this).closest("fieldset").find(".ew_e_time").val();
    var fee_code=$(this).closest("fieldset").attr("fee_code");
    var extra_st_control=$(this).closest("fieldset").find(".extra_st");
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
          //alert(msg);
          var amount=parseFloat(msg);
          if(!isNaN(amount)){
            extra_st_control.closest("fieldset").find("input.doc_ori_amount").val(amount);
            extra_st_control.closest("fieldset").find("input.doc_ori_amount").change();
          }
        },
        error: function(){
          extra_st_control.val("暂无*");
        }
      });
    }
  });
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
      $(this).closest("fieldset").find("div.dep input").removeAttr("disabled");
      $(this).closest("fieldset").find("div.dep a").show();
    }
    else
    {
      $(this).closest("fieldset").find("div.dep input").val("");
      $(this).closest("fieldset").find("div.dep input").attr("readonly","true");
      $(this).closest("fieldset").find("div.dep a").hide();
    }
  });
  $("select.is_self_dep").change();
  //reference changes
  $("input.ref").live("change",reference_change);
  //set sequence
  //set unique num of doc detail
  set_sequence_num();

});

function wait()
{
  $.blockUI({ css: { 
      border: 'none', 
      padding: '15px', 
      backgroundColor: '#000', 
      '-webkit-border-radius': '10px', 
      '-moz-border-radius': '10px', 
      opacity: .5, 
      color: '#fff'
  },message:'请稍等',
  overlayCSS: { backgroundColor: 'transparent' }}); 
}

function tokenize()
{
  $("input.token-input").each(function(){
    $(this).tokenInput("/token_input/search?model="+$(this).data("model")
    ,{
      crossDomain: false,
      prePopulate: $(this).data("pre"),
      searchingText: "搜索中...",
      hintText: "输入进行搜索",
      noResultsText: "无符合条件的记录",
      theme: "facebook",
      preventDuplicates: true,
      tokenLimit: 1
    });  
  });

}
//reference change
function reference_change()
{
  //change the rate
	if($(this).attr("id")=="currency_info")
	{
		var other_info=$(this).siblings(".ref_hidden_field").attr("data-other-info");
		//find the rate input 
		var rate_input=$(this).closest("fieldset").find(".doc_rate");
		if(rate_input.size()>0 && other_info!=null)
		{
			rate_input.val(other_info.split('_')[0]);
			rate_input.change();
		}
	}
  //change the bank and bank no
	if($(this).attr("id")=="supplier_info")
	{
		var other_info=$(this).siblings(".ref_hidden_field").attr("data-other-info");
    var infos=other_info.split(',');
		//find the bank 
		var bank=$(this).closest("fieldset.reciver").find(".bank");
		if(bank.size()>0)
		{
			bank.val(infos[0]);
		}
    //find the bank no
    var bank_no=$(this).closest("fieldset.reciver").find(".bank_no");
    if(bank_no.size()>0)
    {
      bank_no.val(infos[1]);
    }
	}
}
function adapt_apply_amount_by_rate()
{
	var tr= $(this).closest("fieldset");
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
			//$("div.is_split_reim").find("table tr.fields").hide().find("td:last input").val("true");
      $("fieldset.split legend input:hidden").val(true);//remove();
			$("div.is_split_reim").hide("slow");		      
		}
		//set the doc head's project and afford dep readonly 
		if($(this).val()==0)
		{
			//set project
			$(this).closest("div.form_block").find("div.project input").removeAttr("disabled");
			$(this).closest("div.form_block").find("div.project a").show();
			//set afford dep 
			$("div.afford_dep input").removeAttr("disabled");
			$("div.afford_dep a").show();			
		}
		else
		{
			//set project
			$(this).closest("div.form_block").find("div.project input").val("");
			$(this).closest("div.form_block").find("div.project input").attr("readonly","true");
			$(this).closest("div.form_block").find("div.project a").hide();
			//set afford dep
			$("div.afford_dep input").val("");
			$("div.afford_dep input").attr("readonly","true");
			$("div.afford_dep a").hide();			
		}
	});
}

function remove_fields(link) {
  if(!confirm("是否真的要删除?")) return;
    $(link).prev("input[type=hidden]").val("true");  
    $(link).closest("fieldset").hide(); 
	//set_unique_sequence_num($(link).closest("table.form_input").find("input.table_row_sequence").not('input[value=true]'));
	//invoke the calcalate number
	$("input.doc_ori_amount,input.doc_rate,input.doc_HR_amount,input.doc_FI_amount,input.percent_amount").change();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).closest("div.doc_detail").find("div.form_area").append(content.replace(regexp, new_id));
  //set unique num of doc detail
  set_sequence_num();
	//wrap the datatime picker
	$(".datepicker").datepicker();
	$(".datetimepicker").datetimepicker();
	//set the doc state
	//set_form_state();
	//set reference readonly
	$("input.ref").attr("readonly",true);
	//set the fee standard readonly
	$(link).closest("fieldset").prev().find("input.fee_standard").attr("readonly",true);
	//fire get fee
	$(link).closest("fieldset").prev().find(".region_type_select").change();
	//enable the enter to tab
	add_enter_to_tab();
}


function add_upload_files(current,path)
{
	sFeatures="dialogHeight: 300px; dialogWidth: 600px;dialogTop: 190px;dialogLeft: 220px; edge:Raised;border:thin;location:no; center: Yes;help: No; resizable: No; status: No;"
	var doc_no=$("span.doc_no").text();
	window.showModalDialog(path+"?doc_no="+doc_no,'',sFeatures);
}
function removeSelected(remove_link)
{
	$(remove_link).parent().find("select :selected").remove();
	//set_form_state();
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
	path="/ref_form/index?class_name="+$(this).attr('class-data')+"&values="+value_now;
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

	sFeatures="dialogHeight: 480px; dialogWidth: 686px;dialogTop: 190px;dialogLeft: 220px; edge:Raised;border:thin;location:no; center: Yes;help: No; resizable: No; status: No; titlebar: No; menubar: No;"

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
		//set other infos
		$(this).siblings(".ref_hidden_field").attr("data-other-info",returnValue.other_infos);
		//fire the change event so now you can get the fee standard
		$(this).siblings(".ref,.ref_hidden_field").change();
	}
	return false;
}
//set the selected value the result
//close the window
function back_to_the_reference()
{
	var ids="";
	var displays="";
	var other_infos="";
	$("input:checked.ref_select").each(function(){
		ids += $(this).siblings("input.hidden_id").val() + "_";
		displays += $(this).siblings("input.hidden_display").val() + ";";
		other_infos+=$(this).siblings("input.hidden_other_info").val() + ";";
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
	if(other_infos.length>0)
	{
		other_infos=other_infos.substring(other_infos.length-1,"");
	}
	//alert($("input:checked.ref_select").size());
	var returnInfo=new Object();
	returnInfo.ids=ids;
	returnInfo.displays=displays;
	returnInfo.other_infos=other_infos;
	//returnInfo.id=
	//$()
	//set the return value
	window.returnValue=returnInfo;
	//close the window
	window.close();
}
function batch_pay(grid_id)
{
	var ids=$(grid_id).getGridParam("selarrrow");
	if(ids.length==0)
	{
		alert("请选择需要付款的单据");
		return;
	}
	if(ids.length>=0)
	{
		$.ajax({
		  type: "GET",
		  url: "/doc_heads/batch_pay",
		  data: "doc_ids="+ids.join('_'),
		  beforeSend: function(){
				//fee_standard_control.val("正在获取...");
				$.blockUI({ message:"付款中，请稍后..." }); 
		  },
		  success: function(msg){
				$(grid_id).trigger("reloadGrid");
				$.unblockUI(); 
		  },
			error: function(){
				$(grid_id).trigger("reloadGrid");
				$.unblockUI();
			}
		});	
	}
}
function batch_print(grid_id)
{
	var ids=$(grid_id).getGridParam("selarrrow");
	if(ids.length>0)
	{
		window.location="/doc_heads/batch_print?"+"doc_ids="+ids.join('_');
	}
	else
	{
		alert("请选择需要打印的单据");
	}
}
function batch_approve(grid_id)
{
	var ids=$(grid_id).getGridParam("selarrrow");
	if(ids.length==0)
	{
		alert("请选择需要审批的单据");
		return;
	}
	if(ids.length>0)
	{
		//clear previsou value
		$("#is_ok").attr("checked",false);
		$("#comments").val("");
		$.blockUI({ message: $('#approve_info') });
	}
}
function batch_approve_confirm(grid_id)
{
	//get all doc id and invoke a ajax call
	var ids=$(grid_id).getGridParam("selarrrow");
	var doc_ids=ids.join('_');
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
			$(grid_id).trigger("reloadGrid");
			$.unblockUI();
	  },
		error: function(){
			$(grid_id).trigger("reloadGrid");
			$.unblockUI();
		}
	});	
}
function output_to_txt(grid_id)
{
	send_request_from_grid(grid_id,"/doc_heads/output_to_txt.txt?ids=");
}
function output_to_txt_all()
{
	var url="/doc_heads/output_to_txt_all.txt";
	document.location.href = url;
}
function output_to_excel(grid_id)
{
	send_request_from_grid(grid_id,"/doc_heads/export_xls.xls?ids=");
}
function g_vouch (grid_id) {
  if(confirm("是否重新生成已有数据？"))
  {
    send_request_from_grid(grid_id,"/vouch/index?rg=true&doc_ids=");
  }
  else
  {
    send_request_from_grid(grid_id,"/vouch/index?doc_ids=");
  }
}
function delete_docs(grid_id) 
{
  var answer=confirm("是否真的删除这些单据，删除的单据将无法恢复！");
  if(!answer)
  {
    return;
  }
	//get all doc id and invoke a ajax call
	var ids=$(grid_id).getGridParam("selarrrow");
	var doc_ids=ids.join(',');
	var is_ok=$("#is_ok").is(':checked');
	var comments=$("#comments").val();
	//make a ajax call
	$.ajax({
	  type: "DELETE",
	  url: "/doc_heads/destroy",
	  data: "doc_ids="+doc_ids,
	  beforeSend: function(){
			//fee_standard_control.val("正在获取...");
			$.blockUI({ message:"正在删除..." }); 
	  },
	  success: function(msg){
			$(grid_id).trigger("reloadGrid");
			$.unblockUI();
	  },
		error: function(){
			$(grid_id).trigger("reloadGrid");
			$.unblockUI();
		}
	});	
}
function send_request_from_grid(grid_id,url)
{
	//get all doc id and invoke a ajax call
	var ids=$(grid_id).getGridParam("selarrrow");
	if(ids.length==0)
	{
		alert("请选择需要操作的单据");
		return;
	}
	//trim the ;
	if(ids.length>0)
	{
		document.location.href = url+ids.join(',');
	}
}

function cancel_edit_form (cancel_link) {
  $(cancel_link).closest("form").hide("fast");
  //show the show item
  $(cancel_link).closest(".list_item").find("div.show").show("slow");
}



