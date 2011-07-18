require 'rubygems'

desc "Build doc row 's index "
task :build_doc_index => :environment do
  puts 'first delete all datarows....'
  DocRow.delete_all
  puts 'deleted....'
  resources = %w(BorrowDocDetail PayDocDetail RdBenefit RdCommonTransport RdExtraWorkCar RdExtraWorkMeal RdLodging RdTransport 
                RdTravel RdWorkMeal OtherRiem RdCommunicate)
  resources.each do |resource|
    puts "begin index #{resource}"
    model = Kernel.const_get(resource)
    model.all.each do |doc_row|
      doc = doc_row.doc_head
      next if !doc
      dr = DocRow.new
      dr.apply_amount = doc_row.apply_amount
      dr.doc_head_id  = doc_row.doc_head_id
      if doc_row.respond_to? :dep_id
        dr.dep_id     = doc_row.dep_id
      else
        dr.dep_id     = doc.afford_dep_id
      end
      if doc_row.respond_to?  :project_id
        dr.project_id = doc_row.project_id
      else
        dr.project_id = doc.project_id
      end
      if doc_row.respond_to?  :fee_id
        dr.fee_id = doc_row.fee_id
      end
      dr.apply_date = doc.apply_date
      dr.doc_total_amount = doc.total_amount
      dr.person_id  = doc.person_id
      dr.doc_no     = doc.doc_no
      dr.doc_state     = doc.state
      dr.resource_id = doc_row.id
      dr.resource_type = resource
      puts "#{doc_row.id} saved to doc rom index table..."
      dr.save
    end
  end
  
end

