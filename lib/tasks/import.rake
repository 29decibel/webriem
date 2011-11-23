namespace :vrv do
  desc "import people"
  task :import_people => :environment do
    csv = File.expand_path('../../../db/person.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        puts line
      end
    end
  end

  desc "import deps"
  task :import_deps => :environment do
    csv = File.expand_path('../../../db/dep.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        name,code = line.splits(',')
        dep = Dep.build(:name=>name,:code=>code)
        if dep.save
          if dep.code.size>2
            dep.update_attribute(:parent_dep_id,Dep.find_by_code(dep.code[0..-3]).try(:id))
          end
        else
          puts "error from #{line};#{dep.errors}"
        end
      end
    end
  end
end
