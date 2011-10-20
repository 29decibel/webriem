namespace :vrv do
  desc "import people"
  task :import_people => :environment do
    csv = File.expand_path('../../../db/people_vrv.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        puts line
      end
    end
  end
end
