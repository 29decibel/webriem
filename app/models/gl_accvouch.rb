class GLAccvouch < ActiveRecord::Base
  establish_connection :host=>'10.120.128.28',:database=>'UFDATA_500_2011',:username=>'sa',:password=>''
  set_table_name 'gl_accvouch'
end
