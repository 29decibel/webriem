class DocOffSetController < ApplicationController
  def index
  end
  def search  
    @docs_by_person={}
    #[:riem_docs] [:cp_docs]
    persons=Person.where("name like ?","%#{params[:person]}%").all
    persons.each do |p|
      riem_docs=DocHead.where("person_id = ? and doc_type between 9 and 13 and doc_state=2",p.id).all
      cp_docs=DocHead.where("person_id = ? and doc_type =1 and doc_state=3",p.id).all
      if riem_docs.count>0 and cp_docs.count>0
        @docs_by_person[p]={:riem_docs=>riem_docs,:cp_docs=>cp_docs}
      end
    end
  end

end
