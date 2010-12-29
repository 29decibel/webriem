#coding: utf-8
class DepGridPanel < Netzke::Basepack::GridPanel
  def default_config
    super.merge(:model => "Dep",:title=>"部门列表")
  end
  # overriding 2 GridPanel's methods
  def default_bbar
  end

  def default_context_menu
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
        window.location="/deps/"+record.get('id');
      });
    }
  JS
end