#coding: utf-8
class MyDocsGridPanel < Netzke::Basepack::GridPanel
  action :print_docs, :text => "打印选中", :disabled => false
  def default_config
    super.merge({:model => "DocHead"})
  end
  # overriding 2 GridPanel's methods
  def default_bbar
    [:print_docs.action]
  end

  def default_context_menu
    #[:show_details.action, "-", *super]
    [:print_docs.action]
  end
  js_method :init_component, <<-JS
    function(){
      //call the parent
      this.selModel = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
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
  # Method in the JS class that (by default) processes the action's "click" event
  js_method :on_print_docs, <<-JS
    function(){
      // Remotely calling the server's method greet_the_world (defined below)
      var record=this.getSelectionModel().getSelected();
      //alert(record.get('id'));
      window.location="/doc_heads/print?doc_id="+record.get('id');
    }
  JS

 ## Server's method that gets called from the JS
 #endpoint :greet_the_world do |params|
 #  # Tell the client side to call its method showGreeting with "Hello World!" as parameter
 #  {:show_greeting => "Hello World!"}
 #end
end