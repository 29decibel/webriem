$(function(){
	$("input.doc_ori_amount,input.doc_rate,input.doc_HR_amount,input.doc_FI_amount").live("change",adjust_amount);
	//$("input.number").numeric(".");
	init_total_amount();
	$("input.travel_days,input.fee_standard,input.other_fee").live("change",calculate_ori_amount);
	//set all apply amount readonly
	//$("input.doc_apply_amount").attr("readonly",true);
	//$("input.split_percent").live("change",set_split_percent_amount);
	//$("input.split_percent").change();
	$("input.offset_amount").live("change",offset_amount_change);
	$("input.percent_amount").live("change",set_split_total);
	$("input.percent_amount").change();
});
//$("input.doc_apply_amount").attr("readonly","readonly");
function adjust_amount()
{
	//alert($(this).attr("class"));
	var doc_rate=parseFloat($(this).closest("fieldset").find("input.doc_rate").val());
	var doc_ori_amount=parseFloat($(this).closest("fieldset").find("input.doc_ori_amount").val());
	//var doc_apply_amount=$(this).closest("tr").find("input.doc_apply_amount").val();
	var doc_HR_amount=parseFloat($(this).closest("fieldset").find("input.doc_HR_amount").val());
	var doc_FI_amount=parseFloat($(this).closest("fieldset").find("input.doc_FI_amount").val());
	//=====================+++++++++++++++++++++++++++++++++
	if(isNaN(doc_rate))
		doc_rate=0.0;
	if(isNaN(doc_ori_amount))
		doc_ori_amount=0.0;
	if(isNaN(doc_HR_amount))
		doc_HR_amount=0.0;
	if(isNaN(doc_FI_amount))
		doc_FI_amount=0.0;
	//=====================+++++++++++++++++++++++++++++++++
	var current_style_class=$(this).attr("class");
	var setting_value=0.00;
	if(doc_rate)
	{
		setting_value=(doc_ori_amount/doc_rate).toFixed(2);
	}
	else
	{
		setting_value=(doc_ori_amount/1).toFixed(2);
	}
	if(current_style_class.indexOf("doc_rate")>=0 || current_style_class.indexOf("doc_ori_amount")>=0)
	{
		$(this).closest("fieldset").find("input.doc_ori_amount").val(doc_ori_amount);
		$(this).closest("fieldset").find("input.doc_apply_amount").val(setting_value);
		$(this).closest("fieldset").find("input.doc_HR_amount").val(setting_value);
		$(this).closest("fieldset").find("input.doc_FI_amount").val(setting_value);
	}
	if(current_style_class.indexOf("doc_HR_amount")>=0)
	{
		$(this).closest("fieldset").find("input.doc_FI_amount").val(doc_HR_amount);
	}
	//cal all amount
	var total=0;
	var control_to_calculate=find_control_cal_by_tr_wrapper($(this).closest("div.form_area").find("fieldset").not(":hidden"));
  console.log(control_to_calculate);
	//alert($(this).closest("table").find("tr.fields").not(":hidden").size());
	if(control_to_calculate!=0)
	{
		control_to_calculate.each(function(){
			//debugger;
			console.log(this);
			total+=parseFloat($(this).val());
      console.log($(this).val());
      
		});
	}
	$(this).closest("div.doc_detail").find("div.form_title span.doc_total_amount").html(total.toFixed(2));
	//whole page's total amount
	var total_riem=0.00;
	$("span.doc_total_amount").each(function(){
		total_riem+=parseFloat($(this).text());
	});
	//set page's amount
	$("#total_riem").text(total_riem.toFixed(2));
	$("#total_riem").change();
	//set the reciver amount==============================================================
	//只有一个收款人的时候进行total的设置
	if($("fieldset.reciver").not(":hidden").size()==1)
	{
		//whether there is a cp doc exist
		if($("input.offset_amount").size()>0)
		{
			$("input.offset_amount").each(function(){
				var current_amount=parseFloat($(this).val());
				if(!isNaN(current_amount))
					total_riem-=current_amount;
			});
		}
    total_riem=total_riem.toFixed(2);
		if(current_style_class.indexOf("doc_rate")>=0 || current_style_class.indexOf("doc_ori_amount")>=0)
		{
			$("fieldset.reciver").not(":hidden").find("input.doc_ori_amount").first().val(total_riem);
			$("fieldset.reciver").not(":hidden").find("input.doc_HR_amount").first().val(total_riem);
			$("fieldset.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);
		}
		if(current_style_class.indexOf("doc_HR_amount")>=0)
		{
			$("fieldset.reciver").not(":hidden").find("input.doc_HR_amount").first().val(total_riem);
			$("fieldset.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);
		}
		if(current_style_class.indexOf("doc_FI_amount")>=0)
		{
			$("fieldset.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);		
		}
	}
  //set unique num of doc detail
  set_sequence_num();
}

function set_sequence_num () {
  //get details
  $("div.doc_detail").each(function() {
    var count=1;
    $(this).find("fieldset").not(":hidden").find("span.sequence").each(function(){
      //set value
      $(this).html(count);
      count+=1;
    });
  });
}

//寻找该用那个控件进行total value的计算
function find_control_cal_by_tr_wrapper(tr_wrapper)
{
	if(tr_wrapper.find("input.doc_FI_amount").size()>0)
		return tr_wrapper.find("input.doc_FI_amount");
	if(tr_wrapper.find("input.doc_apply_amount").size()>0)
		return tr_wrapper.find("input.doc_apply_amount");
	if(tr_wrapper.find("input.doc_ori_amount").size()>0)
		return tr_wrapper.find("input.doc_ori_amount");
	return 0;
}
function set_split_total()
{
  //alert("aaaa");
	//set self to 2 fixed
	var current_val=parseFloat($(this).val());
  //alert(current_val);
	if(isNaN(current_val))
	{
		current_val=0.0;
	}
	//set me back
	$(this).val(current_val.toFixed(2));
	total_split=0.0;
	$("fieldset.split").not(":hidden").each(function(){
		total_split+=parseFloat($(this).find("input.percent_amount").val());
	});
	$("span.split_total_amount").val(total_split.toFixed(2));
}


function offset_amount_change()
{
	//alert($("tr.reciver").not(":hidden").first().find("input.doc_ori_amount").val());
	$("fieldset.reciver").not(":hidden").first().find("input.doc_ori_amount").change();
	return false;
}

//init total amount
function init_total_amount()
{
  var page_total=0.0;
	$("div.doc_detail").each(function(){
		var total=0.00;
    //alert($(this).find("input.doc_FI_amount").size());
    var amount_controls=$(this).find("input.doc_FI_amount");
    if(amount_controls.size()==0)
    {
      amount_controls=$(this).find("input.doc_apply_amount");
    }
		amount_controls.each(function(){
			total+=parseFloat($(this).val());
		});
		$(this).find("span.doc_total_amount").html(total.toFixed(2));
    page_total+=total;
		$("input.doc_total_amount").change();
	});
  //set page total
  $("#total_riem").text(page_total.toFixed(2));
	$("#total_riem").change();
	//set split if 
	if($("div.is_split_reim").size()>=1)
	{
		$("input.percent_amount").first().change();
	}
}

function calculate_ori_amount()
{
	var days= parseFloat($(this).closest("fieldset").find("input.travel_days").val());
	var fee_standard=parseFloat($(this).closest("fieldset").find("input.fee_standard").val());
	//var other_fee=parseFloat($(this).closest("tr").find("input.other_fee").val());
	//if(isNaN(other_fee))
	//	other_fee=0;
	if(!isNaN(days) && !isNaN(fee_standard))
	{
		var total=(days*fee_standard).toFixed(2);
		$(this).closest("fieldset").find("input.doc_ori_amount").val(total);
		$(this).closest("fieldset").find("input.doc_ori_amount").change();
	}
}
