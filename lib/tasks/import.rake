namespace :vrv do
  desc "import people"
  task :import_people => :environment do
    Person.where("name!=?",'staff').delete_all
    csv = File.expand_path('../../../db/person.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        next if line[0..2]=='...'
        data = line.split(',')
        attrs = {}
        attrs[:name] = data[3]
        attrs[:code] = data[5]
        attrs[:dep] = Dep.find_by_name(data[1])
        attrs[:duty] = (Duty.find_by_name(data[9]) || Duty.create(:name=>data[9]))
        attrs[:employ_category] = data[6]
        attrs[:duty_level] = data[7]
        attrs[:duty_category] = data[8]
        attrs[:duty_name] = data[9]
        attrs[:birthday] = data[10]
        attrs[:gender] = data[12]
        attrs[:start_date] = data[14]
        attrs[:e_mail] = data[15]
        p = Person.new attrs
        if !p.save
          puts "error from #{line};#{p.errors.full_messages};#{attrs}"
        end
      end
    end
  end

  desc "import deps"
  task :import_deps => :environment do
    Dep.delete_all
    csv = File.expand_path('../../../db/dep.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        name,code = line.split(',')
        next if name.blank? or code.blank?
        dep = Dep.new(:name=>name,:code=>code,:start_date => Time.now.to_date)
        if dep.save
          if dep.code.size>2
            dep.update_attribute(:parent_dep_id,Dep.find_by_code(dep.code[0..-3]).try(:id))
          end
        else
          puts "error from #{line};#{dep.errors.full_messages}"
        end
      end
    end
  end
end
