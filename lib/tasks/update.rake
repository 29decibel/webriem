namespace :update do
  desc "update person"
  task :factors => :environment do
    Person.all.each{|p|p.save}
  end
end
