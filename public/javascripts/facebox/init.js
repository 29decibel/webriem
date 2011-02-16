$(function(){
	$.facebox.settings.closeImage = '/images/facebox/closelabel.png';
	$.facebox.settings.loadingImage = '/images/facebox/loading.gif';
	$("#mark_the_doc").hide();
});
//some methods that use facebox
//jQuery(document).ready(function($) {
//  $('a.facebox').facebox(); 
//});
function write_mark_info(grid_id)
{
  var ids=$(grid_id).getGridParam("selarrrow");
  if(ids.length==0)
  {
    alert("��ѡ����Ҫ����ĵ���");
    return;
  }
  //$("#mark_the_doc").facebox();
  jQuery.facebox({ div: '#mark_the_doc' });
}
function mark(grid_id)
{
  mark_docs(grid_id,"ok");
}
function unmark(grid_id)
{
  mark_docs(grid_id,"");
}
function mark_docs(grid_id,mark_info)
{
  var ids=$(grid_id).getGridParam("selarrrow");
  if(ids.length==0)
  {
    alert("��ѡ����Ҫ�����ĵ���");
    return;
  }
  var mark="ok";//$("#mark_info").text();
  $.ajax({
    type: "GET",
    url: "/doc_heads/mark",
    data: "doc_ids="+ids+"&mark="+mark_info,
    success: function(msg){
      $(grid_id).trigger("reloadGrid");
      jQuery(document).trigger('close.facebox');
    },
    error: function(){
      $(grid_id).trigger("reloadGrid");
      jQuery(document).trigger('close.facebox')
    }
  });
}

