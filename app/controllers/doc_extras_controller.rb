class DocExtrasController < InheritedResources::Base
  respond_to :html,:js
  belongs_to :doc_head
  def create
    create! do
      redirect_to @doc_head
      return
    end
  end

  def destroy
    destroy! do
      redirect_to @doc_head
      return
    end
  end
end
