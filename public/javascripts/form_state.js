//this is used for control the doc state 
$(function(){
	set_form_state();	
});

function set_form_state()
{
	var form_state=$("#form_state").val();
	if(form_state==undefined) return;
	if(form_state==0)
	{
		alert("ok");
		//do nothing
		enable_all_inputs();
	}
	else if(form_state==-1)
	{
		disable_all_inputs();
	}
	else
	{
		disable_all_inputs();
		//control some rows,like hr amount and caiwu amount is ok
		$("input.ok").attr("readonly","false");
	}
}

function disable_all_inputs()
{
	alert("disable");
	//inputs
	$("form.edit_doc_head input").attr("readonly","true");
	$("form.edit_doc_head textarea").attr("readonly","true");
	$("form.edit_doc_head select").attr("disabled","disabled");
	//disable link and reference
	$('form.edit_doc_head a.detail_link').hide();
	$('form.edit_doc_head span.reference').closest('a').hide();
}

function enable_all_inputs()
{
	display("enabled");
	//inputs
	$("form.edit_doc_head input").attr("readonly","false");
	$("form.edit_doc_head textarea").attr("readonly","false");
	$("form.edit_doc_head select").attr("disabled","false");
	//disable link and reference
	$('form.edit_doc_head a.detail_link').show();
	$('form.edit_doc_head span.reference').closest('a').show();
}