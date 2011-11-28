class ActivityController < ApplicationController
  before_filter :authenticate_user!

  def recent
    @versions = VrvProjectVersion.from_web.order('created_at desc').limit(100)
    @activities = []
    @versions.each do |v|
      user = User.find(v.whodunnit).person.try(:name)
      event = I18n.t("actions.#{v.event}")
      current_item = (eval(v.item_type).send(:find_by_id,v.item) || v.reify || v.next.reify)
      change = v.changeset if v.event=='update'
      css = case v.event
            when 'create'
              'success'
            when 'destroy'
              'error'
            when 'update'
              'info'
            end
      time = v.created_at.strftime(('%Y-%m-%d %H:%M:%S'))
      @activities << {:user=>user,:event=>event,:current_item=>current_item,:change=>change,:time=>time,:v=>v,:css=>css}
    end
  end

end
