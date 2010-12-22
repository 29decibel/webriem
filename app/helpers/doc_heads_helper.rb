#coding: utf-8
module DocHeadsHelper
  # given the project,fee,dep,month
  def budget_area(project_id,fee_id,dep_id,year,doc_id,doc_type)
    javascript_tag <<-JS
    jQuery(document).ready(function(){ 
      //set up the jqgrid
      jQuery("#jgrid").jqGrid({
        url:'/ajax_service/getbudget?project_id=#{project_id}&fee_id=#{fee_id}&dep_id=#{dep_id}&year=#{year}&doc_id=#{doc_id}&doc_type=#{doc_type}',
        datatype: 'xml',
        mtype: 'GET',
        colNames:['费用类型','预算部门', '预算项目','本年预算','已使用','审批中使用','本次使用','剩余预算'],
        colModel :[ 
          {name:'fee', index:'fee', sortable:false}, 
          {name:'dep', index:'dep', sortable:false}, 
          {name:'project', index:'project', sortable:false}, 
    			{name:'current_year', index:'current_year', sortable:false,formatter:'currency', formatoptions:{prefix: "￥ "}}, 
    			{name:'used', index:'used', sortable:false,formatter:'currency', formatoptions:{prefix: "￥ "}}, 
    			{name:'approving_used', index:'approving_used', sortable:false,formatter:'currency', formatoptions:{prefix: "￥ "}}, 
    			{name:'this_used', index:'this_used', sortable:false,formatter:'currency', formatoptions:{prefix: "￥ "}}, 
    			{name:'remain', index:'remain', sortable:false,formatter:'currency', formatoptions:{prefix: "￥ "}}, 			
        ],
        rowNum:2,
        rowList:[2,4,6],
        sortname: 'invid',
        sortorder: 'desc',
        viewrecords: true,
        caption: '预算信息',
    		height:40,
    		width:750,
    		hiddengrid: true,
    		scroll:true,
    		xmlReader : { 
    		      root: "budgets", 
    		      row: "budget",
    					repeatitems:false
    		   },
    		loadComplete: function(data){
    		  //reset_budget_value();
    		}
      }); 
      //register the doc's project and dep's select event in order to change the budget info 
      $(".doc_apply_date,.doc_afford_dep,.doc_project").live("change",reload_budget_info);
      //do the calculate
      $("span#total_riem").live("change",reset_budget_value);
    });
    function reload_budget_info()
    {
      var dep_id=$(".doc_afford_dep").val();
      var project_id=$(".doc_project").val();
      var year=$(".doc_apply_date").val().split('-')[0];
      var doc_id=$("#doc_head_id").val();
      var doc_type=$("#doc_head_doc_type").val();
      var url="/ajax_service/getbudget?project_id="+project_id+"&fee_id=#{fee_id}&dep_id="+dep_id+"&year="+year+"&doc_id="+doc_id+"&doc_type="+doc_type;
      //set the url and reload
      $("#jgrid").setGridParam({'url':url}); 
      $("#jgrid").trigger("reloadGrid");
      reset_budget_value();
    }
    function loadComplete()
    {
      alert("sssss");
    }
    function reset_budget_value()
    {
      var total_riem=parseFloat($(this).text());
      //set this time used
      var current_year=jQuery("#jgrid").jqGrid('getCell',1,'current_year');
      var used=jQuery("#jgrid").jqGrid('getCell',1,'used');
      var approving_used=jQuery("#jgrid").jqGrid('getCell',1,'approving_used');
      //this time
      jQuery("#jgrid").jqGrid('setCell',1,'this_used',total_riem);
      var remain=parseFloat(current_year.substring(1))-parseFloat(used.substring(1))-parseFloat(approving_used.substring(1))-total_riem;
      jQuery("#jgrid").jqGrid('setCell',1,'remain',remain);
    }
    JS
  end
end
