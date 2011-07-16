$config = YAML::load(File.open(Rails.root.join('config/u8service.yml')))
class Accvouch < ActiveRecord::Base
  establish_connection $config['mssql']
end
