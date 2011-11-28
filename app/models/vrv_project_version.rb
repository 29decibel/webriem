class VrvProjectVersion < Version
  # custom behaviour, e.g:
  set_table_name :vrv_project_versions
  attr_accessible :vrv_project_id,:person_id,:state

  scope :from_web,where('whodunnit is not null')

end

