#coding: utf-8
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



  desc "import work flows"
  task :import_wfs => :environment do
    csv = File.expand_path('../../../db/work_flows.csv',__FILE__)
    File.open(csv,'r') do |file|
      while (line=file.gets)
        infos = line.split(',')
        # 广东产品服务中心-普通员工-借款jr,JK,1,报销系统,
        # 部门:广东产品服务中心,岗位级别:普通员工
        # ,
        # 部门:广东产品服务中心,岗位级别:二级部门经理
        # ,
        # 部门:金融能源管理部,岗位级别:总监,岗位名称:项目总监
        # ,
        # 部门:金融能源管理部,岗位级别:一级部门副总经理
        # ,
        # 部门:金融能源管理部,岗位级别:一级部门总经理
        # ,编码:vrv970002,,
        name = infos[0]
        wf = WorkFlow.find_by_name name
        next if wf
        wf = WorkFlow.new :name=>name,:priority=>infos[2],:factors=>infos[4].gsub('^',','),:category=>infos[3]
        # add doc types
        infos[1].split('^').each do |d_code|
          d_meta = DocMetaInfo.find_by_code d_code
          wf.doc_meta_infos << d_meta if d_meta
        end
        # add work flow steps
        infos[5..-1].each do |step|
          next if step.blank?
          ws = wf.work_flow_steps.new :factors=>step.gsub('^',',')
        end
        wf.save

        puts wf.inspect
        wf.work_flow_steps.each do |s|
          puts s.inspect
        end
        
      end
    end
  end
end
