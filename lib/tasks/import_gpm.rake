require 'rubygems'

task :import_gpm => :environment do
  projs=U8service::API.get_gpm_projects
  if projs and projs.count>0
    projs.each do |p|
      if p.valid?
        p.status=1 and p.save 
      end
    end
  end
end
