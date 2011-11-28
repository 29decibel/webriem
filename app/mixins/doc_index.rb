# this is the module used to index 
# the doc rows
module DocIndex
  def self.included(klass)
    klass.class_eval <<-EOF
      def index_doc_row
        logger.info '----------------------'
        logger.info 'begin index doc row'
        return if !doc_head
        # remove exist index
        DocRow.where('resource_type=? and resource_id=?',self.class.name,self.id).delete_all
        # create index row record
        dr = DocRow.new

        dr.apply_amount = self.apply_amount
        dr.doc_head_id  = self.doc_head_id
        if self.respond_to? :dep_id
          dr.dep_id     = self.dep_id
        else
          dr.dep_id     = self.doc_head.afford_dep_id
        end
        if self.respond_to?  :project_id
          dr.project_id = self.project_id
        else
          dr.project_id = self.doc_head.project_id
        end
        if self.respond_to?  :fee_type
          dr.fee_id = self.fee_type.try(:id)
        end
        dr.apply_date = self.doc_head.apply_date
        dr.doc_total_amount = self.doc_head.total_amount
        dr.person_id  = self.doc_head.person_id
        dr.doc_no     = self.doc_head.doc_no
        dr.doc_state     = self.doc_head.state
        dr.resource_id = self.id
        dr.resource_type = self.class.name
        # get changed amount
        dr.changed_amount = DocAmountChange.final_amount(self)
        dr.save
        logger.info 'index over ----------------'
      end
      def delete_doc_row
        DocRow.where('resource_type=? and resource_id=?',self.class.name,self.id).delete_all
      end
    EOF
    klass.after_save :index_doc_row
    klass.after_destroy :delete_doc_row
  end
end
