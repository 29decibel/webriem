//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require lib/jquery-ui-timepicker-addon
//= require lib/jquery-ui-timepicker-zh-CN
//= require enter_to_tab
//= require lib/jquery.tokeninput
//= require twitter/bootstrap
//= require lib/jquery.tablesorter.min
//= require chart/highcharts
//= require chart/themes/gray
//= require site
//= require_self

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
if (typeof console == "undefined" || typeof console.log == "undefined") 
{
   var console = { log: function() {} }; 
}
//------------------------------------------------------------------------

$('.doc_row').live('row:numberChanged',function(){
  var fds = $(this).closest('.form_area').find('.doc_row').not(':hidden');
  console.log(fds);
  var total_num = 0.0;
  //set every fieldset's value
  fds.each(function(){
    //begin set every value
    var apply_amount =  $(this).find('.ori_amount__input').val() / $(this).find('.rate__input').val();
    $(this).find('.apply_amount__input').html(apply_amount.toFixed(2));
    total_num+=apply_amount;
  });
  $(this).closest('.doc_detail').find('.doc_total_amount').text(total_num.toFixed(2));
  $(this).closest('.doc_detail').trigger('area:numberChanged');
});


$('.doc_detail').live('area:numberChanged',function(){
  var total_num = 0.0;
  $('.doc_detail').not('.Reciver').not('.ReimSplitDetail').each(function(){
    var num = parseFloat($(this).find('.doc_total_amount').text());
    total_num+=isNaN(num) ? 0.0 : num;
  });
  //set total amount
  $('.total_amount__input').html(total_num.toFixed(2));
  if($('.Reciver').find('.doc_row').not(':hidden').size()==1)
  {
    $('.Reciver').find('.doc_row').first().find('.amount__input').val(total_num.toFixed(2));
    $('.Reciver .doc_total_amount').text(total_num.toFixed(2));
  }
});

$('.ReimSplitDetail .doc_row').live('row:numberChanged',function(){
  var fds = $(this).closest('.form_area').find('.doc_row').not(':hidden');
  console.log(fds);
  var total_num = 0.0;
  //set every fieldset's value
  fds.each(function(){
    //begin set every value
    var percent_amount =  parseFloat($(this).find('.percent_amount__input').val());
    $(this).find('.percent_amount__input').html(percent_amount.toFixed(2));
    total_num+=percent_amount;
  });
  $(this).closest('.doc_detail').find('.doc_total_amount').text(total_num.toFixed(2));

});

$('.ReimSplitDetail.doc_detail').live('area:numberChanged',function(){
 var fds = $(this).find('.doc_row').not(':hidden');
  console.log(fds);
  var total_num = 0.0;
  //set every fieldset's value
  fds.each(function(){
    //begin set every value
    var percent_amount =  parseFloat($(this).find('.percent_amount__input').val());
    $(this).find('.percent_amount__input').html(percent_amount.toFixed(2));
    total_num+=percent_amount;
  });
  $(this).closest('.doc_detail').find('.doc_total_amount').text(total_num.toFixed(2));

});



function wait()
{
	$("#loading").show();
}
function back()
{
	$("#loading").hide();
	$(".date_select").datepicker({ dateFormat: 'yy-mm-dd' });
	$(".datetime_select").datetimepicker({ dateFormat: 'yy-mm-dd' });
}


//here we bind the data picker control
$(function(){
	$(".date_select").datepicker({ dateFormat: 'yy-mm-dd' });
	$(".datetime_select").datetimepicker({ dateFormat: 'yy-mm-dd' });
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
    back();
  });
  //bind the submit link
  $("a.submit").live("click",function(){
    $(this).closest("form").submit();
    return false;
  });

  //observe the region change so to calculate the fee standard
  $("fieldset").live("change:region_type",function(){
    console.log('change:region_type_select');
    //get the duty id 
    var duty_id=$("#duty_for_fee_standard").val();
    var region_type_id=$(this).find(".region_type_select").val();
    var fee_type=$(this).find("#fee_type").val();
    //person type
    var pt=$("#pt_for_fee_standard").val();
    // make ajax call
    var fee_standard_text = $(this).find(".fee_standard_text");
    var fee_standard = $(this).find(".fee_standard");
    var fieldset = $(this);
    console.log('begin ajax get fee standard...');
    $.ajax({
      type: "GET",
      url: "/ajax_service/getfee",
      data: "region_type_id="+region_type_id+"&duty_id="+duty_id+"&fee_type="+fee_type+"&pt="+pt,
      beforeSend: function(){
        fee_standard_text.html("正在获取...");
      },
      success: function(msg){
        var values=msg.split(",");
        //set fees
        fee_standard.val(values[0]);
        fee_standard_text.html(values[0]);
        console.log('ok get the fees.....')
        if(values.length>1)
        {
          //set currency					
          //fieldset.find(".token-input[data-model=Currency]").tokenInput("clear");
          //fieldset.find(".token-input[data-model=Currency]").tokenInput("add",{id:values[1],name:values[2]});
          console.log('get fees back , begin trigger travel days change');
          //trigger calculate doc_ori_amount
          console.log('final trigger travel days event');
          fieldset.trigger('change:fee_standard');
        }
      },
      error: function(){
        fee_standard_text.html("暂无*");
      }
    });
  });

  $("fieldset").live("change:fee_standard",function(){
    console.log('change:fee_standard');
    if($(this).find('.travel_days').size()>0)
    {
      var fee_standard = parseFloat($(this).find('.fee_standard').val());
      var days = parseFloat($(this).find('.travel_days').val());
      if(!isNaN(fee_standard))
      {
        $(this).closest('fieldset').find('.doc_ori_amount').val((fee_standard*days).toFixed(2));
        $(this).closest('fieldset').trigger("row:numberChanged");
      }
    }
  });

  //observe the time and get the extra work time fee
  $("fieldset").live("change:rd_extra_fee_standard",function(e,data){
    console.log('go-------------');
    console.log(data);
    var fee_type=$(this).find("#fee_type").val();
    var fee_standard_text=$(this).find(".fee_standard_text");
    var fee_standard=$(this).find(".fee_standard");
    var fieldset = $(this);
    if(fee_type!='RdExtraWorkMeal')
      return;
    //make a ajax call and get the fee
    $.ajax({
      type: "GET",
      url: "/ajax_service/get_extrafee",
      data: "is_sunday="+data.is_sunday+"&start_time="+data.start_time+"&end_time="+data.end_time+"&fee_type="+fee_type,
      beforeSend: function(){
        fee_standard_text.html("正在获取...");
      },
      success: function(msg){
        //set fees
        fee_standard_text.html(msg);
        fee_standard.val(msg);
        //alert(msg);
        var amount=parseFloat(msg);
        if(!isNaN(amount)){
          fieldset.find("input.doc_ori_amount").val(amount);
          fieldset.trigger("row:numberChanged");
        }
      },
      error: function(){
        fee_standard_text.val("暂无*");
        fee_standard.val(0);
      }
    });
  });
  //always set the approvers not display
  $("#approvers").css("display","none");
  //always set the approve info form not display
  $("#approve_info").css("display","none");
  //for the work flow page
  $("select.is_self_dep").live("change",function(){
    if($(this).val()==0)
    {
      $(this).closest("fieldset").find("div.select_dep_field").show();
    }
    else
    {
      $(this).closest("fieldset").find("div.select_dep_field").hide();
    }
  });

});

function tokenize(content)
{
  $("input.token-input").each(function(){
    if($(this).css('display')=='none') return;
    $(this).tokenInput("/token_input/search?model="+$(this).data("model")
    ,{
      crossDomain: false,
      prePopulate: $(this).data("pre"),
      searchingText: "搜索中...",
      hintText: "输入进行搜索",
      noResultsText: "无符合条件的记录",
      theme: "facebook",
      preventDuplicates: true,
      tokenLimit: 1,
      onAdd:function(data){
        $(this).trigger('token:add',data);
      },
      onDelete:function(data){
        $(this).trigger('token:delete',data);
      }
    });  
  });

}


function remove_fields(link) {
  if(!confirm("是否真的要删除?")) return;
  // get form area first
  var form_area = $(link).closest('.form_area');
  // remove
  if($(link).closest('.doc_row').hasClass('exist'))
  {
    $(link).closest('.doc_row').find('.destroy_mark').val("true");  
    $(link).closest(".doc_row").hide(); 
  }
  else
  {
    $(link).closest('.doc_row').remove();
  }
  // recalculate
  var fds = form_area.find('.doc_row').not(':hidden');
  var total_num = 0.0;
  //set every fieldset's value
  fds.each(function(){
    //begin set every value
    var apply_amount =  $(this).find('.ori_amount__input').val() / $(this).find('.rate__input').val();
    $(this).find('.apply_amount__input').html(apply_amount.toFixed(2));
    total_num+=apply_amount;
  });
  form_area.closest('.doc_detail').find('.doc_total_amount').text(total_num.toFixed(2));
  form_area.closest('.doc_detail').trigger('area:numberChanged');
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).closest("div.doc_detail").find("div.form_area").append(content.replace(regexp, new_id));
  //set unique num of doc detail
	//set the fee standard readonly
  $(link).closest('.doc_detail').find('fieldset').not(':hidden').last().trigger('change:region_type');
  $(link).closest('.doc_detail').find('fieldset').not(':hidden').last().addClass('new');
  //enable the enter to tab
	add_enter_to_tab();
  //tokenize
  tokenize();
	$(".date_select").datepicker({ dateFormat: 'yy-mm-dd' });
	$(".datetime_select").datetimepicker({ dateFormat: 'yy-mm-dd' });
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



function cancel_edit_form (cancel_link) {
  $(cancel_link).closest("form").hide("fast");
  //show the show item
  $(cancel_link).closest(".list_item").find("div.show").show("slow");
}

// just for ajax history state
if (history && history.pushState) {  
  $(function () {  
    $('a[data-remote=true]').live('click', function () {  
      //var link = $(this);
      console.log('push to history state');
      history.pushState(null, document.title, this.href);  
      return false;  
    });  
    
    $('.search_form a').live('click',function () {  
      console.log('get form data and save state...');
      var action = $('.search_form form').attr('action');  
      var formData = $('.search_form form').serialize();  
      //$.get(action, formData, null, 'script');  
      history.replaceState(null, document.title, action + "?" + formData);  
      return false;  
    });  
    
    $(window).bind("popstate", function () {  
      console.log(window.history);
      wait();
      $.getScript(location.href,function(){
        back();
      });  
    });  
  })  
}  

function draw_chart(ele,title,data)
{
   chart = new Highcharts.Chart({
      chart: {
         renderTo: ele,
         plotBackgroundColor: null,
         plotBorderWidth: null,
         plotShadow: false
      },
      credits:{enabled:false},
      title: {
        text: title
      },
      tooltip: {
         formatter: function() {
            return '<b>'+ this.point.name +'</b>: ￥'+ this.y ;
         }
      },
      plotOptions: {
         pie: {
            allowPointSelect: true,
            cursor: 'pointer',
            dataLabels: {
               enabled: true,
               color: Highcharts.theme.textColor || '#000000',
               connectorColor: Highcharts.theme.textColor || '#000000',
               formatter: function() {
                  return '<b>'+ this.point.name +'</b>: ￥'+ this.y ;
               }
            }
         }
      },
       series: [{
         type: 'pie',
         name: 'Browser share',
         data: data
      }]
   });
}

$(function(){
  $("#change_locale").change(function(){
    window.location = '/home/change_locale?locale='+$("#change_locale").val();
  });
});


