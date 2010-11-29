AdminData::Config.set = {
  :is_allowed_to_view => lambda {|controller| current_user.name=="admin" },
  :is_allowed_to_update => lambda {|controller| current_user.name=="admin"},
}