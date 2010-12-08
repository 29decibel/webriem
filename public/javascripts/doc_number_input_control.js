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
});
//$("input.doc_apply_amount").attr("readonly","readonly");
function adjust_amount()
{
	//alert($(this).attr("class"));
	var doc_rate=parseFloat($(this).closest("tr").find("input.doc_rate").val());
	var doc_ori_amount=parseFloat($(this).closest("tr").find("input.doc_ori_amount").val());
	//var doc_apply_amount=$(this).closest("tr").find("input.doc_apply_amount").val();
	var doc_HR_amount=parseFloat($(this).closest("tr").find("input.doc_HR_amount").val());
	var doc_FI_amount=parseFloat($(this).closest("tr").find("input.doc_FI_amount").val());
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
		$(this).closest("tr").find("input.doc_ori_amount").val(doc_ori_amount);
		$(this).closest("tr").find("input.doc_apply_amount").val(setting_value);
		$(this).closest("tr").find("input.doc_HR_amount").val(setting_value);
		$(this).closest("tr").find("input.doc_FI_amount").val(setting_value);
	}
	if(current_style_class.indexOf("doc_HR_amount")>=0)
	{
		$(this).closest("tr").find("input.doc_FI_amount").val(doc_HR_amount);
	}
	//cal all amount
	var total=0;
	var control_to_calculate=find_control_cal_by_tr_wrapper($(this).closest("table").find("tr.fields").not(":hidden"));
	//alert($(this).closest("table").find("tr.fields").not(":hidden").size());
	control_to_calculate.each(function(){
		//debugger;
		//alert(this);
		total+=parseFloat($(this).val());
	});
	$(this).closest("table").find("input.doc_total_amount").val(total.toFixed(2));
	//whole page's total amount
	var total_riem=0.00;
	$("input.doc_total_amount").each(function(){
		total_riem+=parseFloat($(this).val());
	});
	//set page's amount
	$("#total_riem").text(total_riem.toFixed(2));
	//set the reciver amount==============================================================
	//只有一个收款人的时候进行total的设置
	if($("tr.reciver").not(":hidden").size()==1)
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
			$("tr.reciver").not(":hidden").find("input.doc_ori_amount").first().val(total_riem);
			$("tr.reciver").not(":hidden").find("input.doc_HR_amount").first().val(total_riem);
			$("tr.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);
		}
		if(current_style_class.indexOf("doc_HR_amount")>=0)
		{
			$("tr.reciver").not(":hidden").find("input.doc_HR_amount").first().val(total_riem);
			$("tr.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);
		}
		if(current_style_class.indexOf("doc_FI_amount")>=0)
		{
			$("tr.reciver").not(":hidden").find("input.doc_FI_amount").first().val(total_riem);		
		}
	}
	//======================================================================================
	//if($("div.is_split_reim").size()>=1)
	//{
		//set_split_percent_amount();
	//}
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
}
function set_split_percent_amount()
{
	//get total amount
	var total_riem=0.00;
	$("input.doc_total_amount").each(function(){
		total_riem+=parseFloat($(this).val());
	});
	$("div.is_split_reim table tr").not(":hidden").find("input.split_percent").each(function(){
		var v=$(this).val()*total_riem/100;
		$(this).closest("tr").find("input.percent_amount").val(v.toFixed(2));
	});
}

function offset_amount_change()
{
	//alert($("tr.reciver").not(":hidden").first().find("input.doc_ori_amount").val());
	$("tr.reciver").not(":hidden").first().find("input.doc_ori_amount").change();
	return false;
}

//init total amount
function init_total_amount()
{
	$("table").each(function(){
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
		$(this).find("input.doc_total_amount").val(total.toFixed(2));
	});
}

function calculate_ori_amount()
{
	var days= parseFloat($(this).closest("tr").find("input.travel_days").val());
	var fee_standard=parseFloat($(this).closest("tr").find("input.fee_standard").val());
	//var other_fee=parseFloat($(this).closest("tr").find("input.other_fee").val());
	//if(isNaN(other_fee))
	//	other_fee=0;
	if(!isNaN(days) && !isNaN(fee_standard))
	{
		var total=(days*fee_standard).toFixed(2);
		$(this).closest("tr").find("input.doc_ori_amount").val(total);
		$(this).closest("tr").find("input.doc_ori_amount").change();
	}
}
