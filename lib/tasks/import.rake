require 'rubygems'
require 'parseexcel' 
require 'excelsior'

task :import=>:environment do
  #从命令行输入要打开的excel文件名  
  workbook = Spreadsheet::ParseExcel.parse("#{RAILS_ROOT}/doc/skdocs.xls")  
  #得到第一个表单  
  worksheet = workbook.worksheet(0)  
  #遍历行  
  worksheet.each do |row|  
    #遍历该行非空单元格  
    row.each do |cell|  
      if cell != nil  
        #取得单元格内容为string类型  
        puts cell.to_s('utf-8')  
      end  
    end  
  end 
end

task :import_csv=>:environment do
  rows = []
  Excelsior::Reader.rows(File.open("#{RAILS_ROOT}/doc/skdocs/person-Table.csv", 'rb')) do |row|
   row.each do |value|
     puts value
   end
  end  
end