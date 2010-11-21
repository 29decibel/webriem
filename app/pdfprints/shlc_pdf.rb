#coding: utf-8
class ShlcPdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  attr_accessor :doc
  def self.get_pdf
    
  end
end