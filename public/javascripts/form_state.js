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
	}
	//set hr or fi editable
	if($("#looker").size()>0)
	{
		if($("#looker").val()=="HR")
		{
			$("input.doc_HR_amount").removeAttr("readonly");
		}
		else if($("#looker").val()=="FI")
		{
			$("input.doc_FI_amount").removeAttr("readonly");
		}
	}
	else
	{
		$("input.doc_FI_amount").attr("readonly","true");
		$("input.doc_HR_amount").attr("readonly","true");
	}
	//set total amount always false
	$("input.doc_apply_amount").attr("readonly","true");
	$("input.doc_total_amount").attr("readonly","true");
	//set number stuff
	$("input.number").numeric(".");
	//always set the approvers not display
	$("#approvers").css("display","none");
	$('.number').change(function(){
	  $(this).val(Number($(this).val()).toFixed(2));
	});
}

function disable_all_inputs()
{
	//inputs
	$("form.doc_head input").attr("readonly","true");
	$("form.doc_head textarea").attr("readonly","true");
	$("form.doc_head select").attr("disabled","disabled");
	//disable link and reference
	$('form.doc_head a.detail_link').hide();
	$('a.cp_offset_link').hide();
	$('form.doc_head span.reference').closest('a').hide();
}

function enable_all_inputs()
{
	//inputs
	$("form.doc_head input").not("input.ref").not("input.fee_standard").not("input.table_row_sequence").removeAttr("readonly");
	$("form.doc_head textarea").removeAttr("readonly");
	$("form.doc_head select").removeAttr("disabled");
	//disable link and reference
	$('form.doc_head a.detail_link').show();
	$('a.cp_offset_link').show();
	$('form.doc_head span.reference').closest('a').show();
}