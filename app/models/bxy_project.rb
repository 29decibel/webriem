class BxyProject < ActiveRecord::Base
  belongs_to :person
  validates :name,:presence=>true
  validates :code,:presence=>true

  after_create :create_oes_project

  def create_oes_project
     Project.find_by_code(self.code) || Project.create(:code=>self.code,:name=>self.name)
  end
end
