$(function(){
		$("input.doc_ori_amount,input.doc_rate,input.doc_HR_amount,input.doc_FI_amount").live("change",adjust_amount);
	$("input.number").numeric();
	init_total_amount();
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
	if(current_style_class.indexOf("doc_rate")>=0)
	{
		$(this).closest("tr").find("input.doc_apply_amount").val(doc_rate*doc_ori_amount);
		$(this).closest("tr").find("input.doc_HR_amount").val(doc_rate*doc_ori_amount);
		$(this).closest("tr").find("input.doc_FI_amount").val(doc_rate*doc_ori_amount);
	}
	if(current_style_class.indexOf("doc_ori_amount")>=0)
	{
		$(this).closest("tr").find("input.doc_apply_amount").val(doc_rate*doc_ori_amount);
		$(this).closest("tr").find("input.doc_HR_amount").val(doc_rate*doc_ori_amount);
		$(this).closest("tr").find("input.doc_FI_amount").val(doc_rate*doc_ori_amount);
	}
	if(current_style_class.indexOf("doc_HR_amount")>=0)
	{
		$(this).closest("tr").find("input.doc_FI_amount").val(doc_HR_amount);
	}
	if(current_style_class.indexOf("doc_FI_amount")>=0)
	{}
	//cal all amount
	var total=0;
	$(this).closest("table").find("input.doc_FI_amount").each(function(){
		total+=parseFloat($(this).val());
	});
	$(this).closest("table").find("input.doc_total_amount").val(total);
}

//init total amount
function init_total_amount()
{
	$("table").each(function(){
		var total=0;
		$(this).find("input.doc_FI_amount").each(function(){
			total+=parseFloat($(this).val());
		});
		$(this).find("input.doc_total_amount").val(total);
	});
}