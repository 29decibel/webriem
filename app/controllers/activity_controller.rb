class ActivityController < ApplicationController
  before_filter :authenticate_user!

  def recent
    @versions = Version.order('created_at desc').limit(30)
    @activities = []
    @versions.each do |v|
      user = User.find(v.whodunnit).name
      event = I18n.t("actions.#{v.event}")
      current_item = eval(v.item_type).send(:find,v.item)
      change = changes(v.reify,v.next ? v.next.reify : current_item) if v.event=='update'
      time = v.created_at.strftime(('%Y-%m-%d %H:%M:%S'))
      @activities << {:user=>user,:event=>event,:current_item=>current_item,:change=>change,:time=>time}
    end
  end


  private
  def changes(a,b)
    cols = a.class.column_names.reject{|a| %w(updated_at created_at).include? a}
    changes = {}
    cols.each do |col|
      if a.try(col)!=b.try(col)
        changes[col] = {:from =>a.try(col),:to=>b.try(col)}
      end
    end
    logger.info '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
    logger.info a
    logger.info '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
    logger.info b
    logger.info changes
    logger.info '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'
    changes
  end

end
