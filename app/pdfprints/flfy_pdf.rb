#coding: utf-8
class FlfyPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.get_pdf
    
  end
end