#coding: utf-8
namespace :update do
  desc "update person"
  task :factors => :environment do
    Person.all.each{|p|p.save}
  end

  desc "update person"
  task :person_deps => :environment do
    #person表，cpersoncode 人员编号，cdepcode 部门编号
    sql = "select cpersoncode as p_code,cdepcode d_code from person"
    result = U8Service.exec_sql sql
    puts result
    result.each do |r|
      person = Person.find_by_code(r['p_code'])
      dep = Dep.find_by_code(r['d_code'])
      if dep and person
        person.dep = dep 
        person.save
      end
    end
  end

  desc "set default role"
  task :set_roles => :environment do
    r_id = Role.first.id
    Person.all.each {|p| p.update_attribute :role_id,r_id}
  end
end
