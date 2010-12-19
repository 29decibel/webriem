#coding: utf-8
module DocHeadsHelper
  # given the project,fee,dep,month
  def budget_area(project_id,fee_id,dep_id,month,doc_id)
    javascript_tag <<-JS
    jQuery(document).ready(function(){ 
      jQuery("#jgrid").jqGrid({
        url:'/ajax_service/getbudget?project_id=#{project_id}&fee_id=#{fee_id}&dep_id=#{dep_id}&month=#{month}&doc_id=#{doc_id}',
        datatype: 'xml',
        mtype: 'GET',
        colNames:['费用类型','预算部门', '预算项目','本月预算','已使用','审批中使用','本次使用','剩余预算'],
        colModel :[ 
          {name:'fee', index:'fee', sortable:false}, 
          {name:'dep', index:'dep', sortable:false}, 
          {name:'project', index:'project', sortable:false}, 
    			{name:'current_month', index:'current_month', sortable:false,formatter:'currency', formatoptions:{decimalSeparator:",", thousandsSeparator: ",", decimalPlaces: 2, prefix: "￥ "}}, 
    			{name:'used', index:'used', sortable:false,formatter:'currency', formatoptions:{decimalSeparator:",", thousandsSeparator: ",", decimalPlaces: 2, prefix: "￥ "}}, 
    			{name:'approving_used', index:'approving_used', sortable:false,formatter:'currency', formatoptions:{decimalSeparator:",", thousandsSeparator: ",", decimalPlaces: 2, prefix: "￥ "}}, 
    			{name:'this_used', index:'this_used', sortable:false,formatter:'currency', formatoptions:{decimalSeparator:",", thousandsSeparator: ",", decimalPlaces: 2, prefix: "￥ "}}, 
    			{name:'remain', index:'remain', sortable:false,formatter:'currency', formatoptions:{decimalSeparator:",", thousandsSeparator: ",", decimalPlaces: 2, prefix: "￥ "}}, 			
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
    		   }
      }); 
    });
    JS
  end
end
