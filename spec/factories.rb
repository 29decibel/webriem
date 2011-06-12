Factory.sequence :name do |n|
  "name#{n}"
end

Factory.sequence :code do |n|
  "code#{n}"
end

Factory.define :dep do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.start_date { Time.now }
end

Factory.define :project do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define :settlement do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define :role do |f|
  f.name Factory.next(:name)
end

Factory.define :duty do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define :fee do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define :supplier do |f|
  f.bank 'jiansheyinhang'
  f.bank_no '23523525235'
  f.code {Factory.next(:code)}
end

Factory.define :currency do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.default_rate 1
end

Factory.define :person do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.phone '15910601187'
  f.e_mail 'aaa@aaa.com'
  f.ID_card '23232323'
  f.bank_no '23523525'
  f.bank 'beijing jianshe yinhang'
  f.association :dep
  f.association :duty
  f.association :role
end

Factory.define :work_flow_step do |f|
  f.is_self_dep false
  f.association :dep
  f.association :duty
end

Factory.define :work_flow do |f|
  f.name {Factory.next(:name)}
end

Factory.define :doc_head do |f|
  f.doc_type          1
  f.association :dep
  f.association :person
  f.afford_dep {|u| u.association(:dep)}
end

Factory.define :cp_doc_detail do |f|
  f.association :doc_head
  f.association :dep
  f.association :fee
  f.association :project
  f.association :currency
  f.used_for 'just want some money'
  f.ori_amount 0
  f.rate_amount 0
end

Factory.define :reciver do |f|
  f.bank 'reciver bank'
  f.bank_no 'reciver bank no'
  f.company 'person name'
  f.association :doc_head
  f.association :settlement
  f.association :supplier
  f.amount 0
end

Factory.define :doc_meta_info do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.description 'nothing to say here'
end

  
  
