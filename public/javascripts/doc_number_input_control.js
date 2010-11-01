$(function(){
	$("input.doc_ori_amount,input.doc_rate,input.doc_HR_amount,input.doc_FI_amount").live("change",adjust_amount);
	$("input.number").numeric();
	init_total_amount();
	$("input.travel_days,input.fee_standard,input.other_fee").live("change",calculate_ori_amount);
	//set all apply amount readonly
	//$("input.doc_apply_amount").attr("readonly",true);
});
//$("input.doc_apply_amount").attr("readonly","readonly");
function adjust_amount()
{
	//alert($(this).attr("class"));
	var doc_rate=$(this).closest("tr").find("input.doc_rate").val();
	var doc_ori_amount=$(this).closest("tr").find("input.doc_ori_amount").val();
	//var doc_apply_amount=$(this).closest("tr").find("input.doc_apply_amount").val();
	var doc_HR_amount=$(this).closest("tr").find("input.doc_HR_amount").val();
	var doc_FI_amount=$(this).closest("tr").find("input.doc_FI_amount").val();
	
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
	if(current_style_class.indexOf("doc_rate")>=0)
	{
		$(this).closest("tr").find("input.doc_apply_amount").val(setting_value);
		$(this).closest("tr").find("input.doc_HR_amount").val(setting_value);
		$(this).closest("tr").find("input.doc_FI_amount").val(setting_value);
	}
	if(current_style_class.indexOf("doc_ori_amount")>=0)
	{
			$(this).closest("tr").find("input.doc_apply_amount").val(setting_value);
			$(this).closest("tr").find("input.doc_HR_amount").val(setting_value);
			$(this).closest("tr").find("input.doc_FI_amount").val(setting_value);
	}
	if(current_style_class.indexOf("doc_HR_amount")>=0)
	{
		$(this).closest("tr").find("input.doc_FI_amount").val(doc_HR_amount);
	}
	if(current_style_class.indexOf("doc_FI_amount")>=0)
	{}
	//cal all amount
	var total=0;
	$(this).closest("table").find("tr").not(":hidden").find("input.doc_FI_amount").each(function(){
		total+=parseFloat($(this).val());
	});
	$(this).closest("table").find("input.doc_total_amount").val(total.toFixed(2));
	//set the reciver amount
	total_riem=0.00;
	$("input.doc_total_amount").each(function(){
		total_riem+=parseFloat($(this).val());
	});
	$("tr.reciver").find("input.doc_ori_amount").first().val(total_riem);
}

//init total amount
function init_total_amount()
{
	$("table").each(function(){
		var total=0.00;
		$(this).find("input.doc_FI_amount").each(function(){
			total+=parseFloat($(this).val());
		});
		$(this).find("input.doc_total_amount").val(total.toFixed(2));
	});
}

function calculate_ori_amount()
{
	var days= parseInt($(this).closest("tr").find("input.travel_days").val());
	var fee_standard=parseFloat($(this).closest("tr").find("input.fee_standard").val());
	var other_fee=parseFloat($(this).closest("tr").find("input.other_fee").val());
	if(isNaN(other_fee))
		other_fee=0;
	var total=(days*fee_standard+other_fee).toFixed(2);
	$(this).closest("tr").find("input.doc_ori_amount").val(total);
	$(this).closest("tr").find("input.doc_ori_amount").change();
}