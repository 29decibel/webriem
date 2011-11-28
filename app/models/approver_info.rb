#coding: utf-8
class ApproverInfo < ActiveRecord::Base
  belongs_to :doc_head
  belongs_to :vrv_project
  belongs_to :work_flow_step
  belongs_to :person

  before_create :set_person_select

  def dep
    @dep || (
    if doc_head
      @dep = doc_head.afford_dep || doc_head.real_person.try(:dep) || doc_head.person.dep # only is_self_dep need the change dep accord the real person
    else
      @dep = vrv_project.person.dep
    end)
  end

  def candidates
    if work_flow_step.is_self_dep
      root_dep = dep
      while root_dep do
        ps = Person.where("dep_id=? and #{where_clause}",root_dep.id)
        if ps.count>0
          return ps
        end
        root_dep = root_dep.parent_dep
      end #end while
      []
    else
      Person.where(where_clause)
    end #end is self dep
  end

  # consider if self dep, reject dep factors
  def where_clause
    conditions = ['1=1']
    factor_hash(work_flow_step.factors).each do |k,v|
      next if (work_flow_step.is_self_dep and k=='部门')
      col = en_col_name(k)
      ass = Person.reflect_on_all_associations(:belongs_to).select{|ass|ass.foreign_key==col}.first
      if ass
        v = ass.klass.find_by_name(v).try(:id)
      end
      conditions << " #{col}='#{v}' "
    end
    conditions.join(' and ')
  end


  private
  # set the person if there is only one person
  def set_person_select
    approvers = candidates
    self.person = approvers.first if (approvers.count==1)
  end

  def en_col_name(ch_col_name)
    @cols_array ||= Person.column_names.map {|a| [a,I18n.t("activerecord.attributes.person.#{a}")]}
    @cols_array.select{|a| a[1]==ch_col_name}.first[0]
  end

  def factor_hash(factor_string)
    rule_fa = {}
    factor_string.split(',').each do |f|
      key,value = f.split(':')
      rule_fa[key.strip]=value.try(:strip)
    end 
    rule_fa
  end
end
