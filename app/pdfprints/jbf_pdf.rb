#coding: utf-8
class JbfPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.get_pdf
    
  end
end