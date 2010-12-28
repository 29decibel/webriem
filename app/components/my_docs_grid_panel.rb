#coding: utf-8
class MyDocsGridPanel < Netzke::Basepack::GridPanel
  action :show_details, :text => "打印选中", :disabled => false
  def default_config
    super.merge({:model => "DocHead",:selModel=>"new Ext.grid.CheckboxSelectionModel({singleSelect:true})"})
  end
  # overriding 2 GridPanel's methods
  def default_bbar
    [:show_details.action]
  end

  def default_context_menu
    #[:show_details.action, "-", *super]
    [:show_details.action]
  end
  js_method :init_component, <<-JS
    function(){
      //call the parent
      #{js_full_class_name}.superclass.initComponent.call(this);
      //register a double click event
      /*this.getSelectionModel().on('selectionchange', function(selModel){
        alert(selModel);
      }, this);*/
      //register a double click event
      this.on("rowdblclick",function(grid,rowIndex,e){
        //alert(rowIndex);
        var record=this.getStore().getAt(rowIndex);
        //alert(record.get('doc_no'));
        window.location="/doc_heads/"+record.get('id');
      });
    }
  JS
end