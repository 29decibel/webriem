class<<ActiveRecord::Base
  def searchable_columns
    self.content_columns.select{|c| !(%w[created_at updated_at].include? c.name)}
  end
end