#coding: utf-8
class DocApproveWindow < Netzke::Basepack::Window
  def configuration
    super.merge(
      :items => [:main_form.component]
    )
  end
  component :main_form, {
    :class_name => "DocApproveForm",
    :title => "审批信息"
  }
end

class DocApproveForm < Netzke::Basepack::FormPanel
  def configuration
    super.merge(
      :items => [
        :text_field,
        {:name => :number_field, :attr_type => :integer},
        {:name => :boolean_field, :attr_type => :boolean, :input_value => true},
        {:name => :date_field, :attr_type => :date},
        {:name => :datetime_field, :attr_type => :datetime},
        {:name => :combobox_field, :xtype => :combo, :store => ["One", "Two", "Three"]}
      ]
    )
  end

  def netzke_submit_endpoint(params)
    data = ActiveSupport::JSON.decode(params.data)
    {:feedback => data.each_pair.map{ |k,v| "#{k.humanize}: #{v}" }.join("<br/>")}
  end
end
