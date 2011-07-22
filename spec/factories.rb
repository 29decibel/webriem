Factory.sequence :name do |n|
  "name#{n}"
end

Factory.sequence :code do |n|
  "code#{n}"
end

Factory.sequence :no do |n|
  "some_no_#{n}"
end

Factory.define :dep do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.start_date { Time.now }
end

Factory.define :project do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.association :dep
end

Factory.define(:account) do |f|
  f.name {Factory.next(:name)}
  f.account_no {Factory.next(:no)}
end


Factory.define :settlement do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define(:transportation) do |f|
  f.name Factory.next(:name)
  f.code Factory.next(:code)
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

Factory.define :region do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.association :region_type
end

Factory.define :region_type do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
end

Factory.define :person do |f|
  f.name {Factory.next(:name)}
  f.code {Factory.next(:code)}
  f.phone '15910601187'
  f.sequence(:e_mail) {|n| "quentin#{n}@example.com"}
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

Factory.define :work_flow_info do |f|
  f.approver {|u| u.association(:person)}
  f.is_ok true
  f.comments 'nice'
end

Factory.define :work_flow do |f|
  f.name {Factory.next(:name)}
end

# ------------------ docs here ---------------------
Factory.define :doc_head do |f|
  f.doc_type          1
  f.association :dep
  f.association :person
  f.afford_dep {|u| u.association(:dep)}
end

Factory.define :borrow_doc_detail do |f|
  f.association :doc_head
  f.association :dep
  f.association :fee
  f.association :project
  f.association :currency
  f.rate '23'
  f.used_for 'just want some money'
  f.ori_amount 0
  f.apply_amount 0
end

Factory.define :pay_doc_detail do |f|
  f.association :doc_head
  f.association :dep
  f.association :fee
  f.association :project
  f.association :currency
  f.used_for 'just want some money'
  f.rate '23'
  f.ori_amount 0
  f.apply_amount 0
end

Factory.define :rd_travel do |f|
  f.days        3
  f.association :region
  f.reason    'good'
  f.association :region_type
  f.rate        23.33
  f.ori_amount  233
  f.association  :currency
  f.st_amount   233
end

Factory.define :fixed_property do |f|
  f.type    'good'
  f.name    'fine'
  f.code    'so nice'
  f.buy_unit  234
  f.buy_count 2
  f.original_value  43
  f.keeper  {|u| u.association :person}
  f.association :project
  f.seq_no  '323232525232626'
  f.afford_dep {|u| u.association :dep}
end

Factory.define :inner_cash_draw do |f|
  f.association :account
  f.now_remain_amount 23.43
  f.description 'asdfaf asdfasfa asfd'
end

Factory.define :inner_remittance do |f|
  f.out_account {|u| u.association :account}
  f.in_account {|u| u.association :account}
  f.in_amount_after 2323
  f.amount 234
  f.description 'fasdfadag'
  f.remain_amount 223
  f.now_rate_price 23
  f.association :currency
end

Factory.define :inner_transfer do |f|
  f.out_account {|u| u.association :account}
  f.in_account {|u| u.association :account}
  f.out_amount_before 2323
  f.in_amount_before 232
  f.in_amount_after 2323
  f.amount  2323
  f.description 'asdfadfadgadg'
end

Factory.define :other_riem do |f|
  f.description 'fasdfasdg'
  f.association :currency
  f.rate  23
  f.ori_amount  232
end

Factory.define :rd_benefit do |f|
  f.reim_date 3.days.ago
  f.fee_time_span   23
  f.people_count  342
  f.rate  233
  f.ori_amount  233
  f.association :dep
  f.association :fee
  f.association :project
end

Factory.define :rd_common_transport do |f|
  f.start_place 'beijing'
  f.end_place   'shanghai'
  f.work_date   2.days.ago
  f.start_time  1.month.ago
  f.end_time    20.days.ago
  f.reason      'cool'
  f.rate        234
  f.association  :dep
  f.association  :project
  f.association :currency
  f.ori_amount  23
end

Factory.define :rd_extra_work_car do |f|
  f.start_place 'qianmen'
  f.end_place   'dashilan'
  f.work_date   3.days.ago
  f.is_sunday   1
  f.start_time  4.days.ago
  f.end_time    2.days.ago
  f.reason      'i like it'
  f.rate        23
  f.ori_amount  200
  f.association :currency
end

Factory.define :rd_extra_work_meal do |f|
  f.work_date  1.days.ago
  f.is_sunday 1
  f.start_time  5.days.ago
  f.end_time    3.days.ago
  f.reason      'fasdfadsf'
  f.rate        23
  f.association :currency
  f.ori_amount  2323
end

Factory.define(:rd_lodging) do |f|
  f.association :region
  f.days        3
  f.people_count  3
  f.person_names 'fadfaf'
  f.rate      233
  f.association :currency
  f.ori_amount  232
  f.start_date  4.days.ago
  f.end_date    3.days.ago
  f.association :region_type
end

Factory.define(:common_riem) do |f|
  f.association :fee
  f.association :dep
  f.association :project
  f.description 'ffffff'
  f.association :currency
  f.rate    233
  f.ori_amount  23322
end


Factory.define(:rd_transport) do |f|
  f.start_position  'asdfaf'
  f.end_position    'fffff'
  f.association :transportation
  f.rate      233
  f.reason  'fff'
  f.association :currency
  f.ori_amount  232
  f.start_date  4.days.ago
  f.end_date    3.days.ago
end

Factory.define(:rd_work_meal) do |f|
  f.meal_date   23.days.ago
  f.place       '232332'
  f.people_count  23
  f.person_names  'fadfag asdga'
  f.reason        'sdfasf'
  f.association :currency
  f.rate        23
  f.association :dep
  f.association :project
  f.ori_amount  2323
end


Factory.define(:rd_communicate) do |f|
  f.meal_date   23.days.ago
  f.place       '232332'
  f.people_count  23
  f.person_names  'fadfag asdga'
  f.reason        'sdfasf'
  f.association :currency
  f.rate        23
  f.association :dep
  f.association :project
  f.ori_amount  2323
end

Factory.define(:rec_notice_detail) do |f|
  f.apply_date     3.days.ago
  f.company       'asdfafd'
  f.association :dep
  f.association :project
  f.association :currency
  f.description 'asdfadfa'
  f.amount  233
  f.rate    23
  f.ori_amount  2323
end

Factory.define(:buy_finance_product) do |f|
  f.name  '32323'
  f.rate  23
  f.association :account
  f.buy_date  2.days.ago
  f.redeem_date 1.days.ago
  f.description 'asdfasdfasdfasfasfda'
  f.amount  223
end

Factory.define(:redeem_finance_product) do |f|
  f.name  '32323'
  f.rate  23
  f.association :account
  f.clear_date  2.days.ago
  f.redeem_date 1.days.ago
  f.description 'asdfasdfasdfasfasfda'
  f.amount  223
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

  
  
