//set the selected value the result
//close the window
function back_to_the_reference(grid_id,cancel)
{
	if(cancel)
	{
		window.close();
		return;
	}
	var ids="";
	var displays="";
	var other_infos="";
	//determin is multi select and get ids
	if($(grid_id).getGridParam('multiselect'))
	{
		ids=$(grid_id).getGridParam("selarrrow");
	}
	else
	{
		ids=$(grid_id).getGridParam("selrow");
	}
	console.log(ids);
	if(ids==null)
	{
		alert("请选择记录");
		return;
	}
	//get displays and other infos
	$(ids.toString().split(',')).each(function(){
		row_data=$(grid_id).getRowData(this);
		console.log(row_data);
		displays += row_data["hidden_display"] + ";";
		other_infos+=row_data["other_info"] + ";";
	});
	//trim displays and other infos
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
	//log
	console.log("ids="+ids);
	console.log("displays="+displays);
	console.log("other_infos="+other_infos);
	//set the return value
	window.returnValue=returnInfo;
	//close the window
	window.close();
}