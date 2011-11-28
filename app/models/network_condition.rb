#coding: utf-8
class NetworkCondition < ActiveRecord::Base
  has_paper_trail :class_name=>'VrvProjectVersion',
    :meta=>{:vrv_project_id => Proc.new{|r|r.vrv_project.id},
            :person_id => Proc.new{|r|r.vrv_project.person_id} }

  belongs_to :vrv_project

  IP_ADDRESS = %w(静态 动态 不知道)
  HUB= %w(支持 不支持 不知道)
  DNS_SERVER = %w(有 没有 不知道)
  WINDOWS_DOMAIN = %w(是 不是 不知道)
  NETWORK_CONNECTION = %w(需要 不需要 不知道)
  PHYSICAL_KEEP = %w(隔离 不隔离 两者都有 不知道)
  PORT_LISTEN = %w(是 不是 不知道)
  NETWORK_INSIDE = %w(存在 不存在 不知道)
  validates :ip_address,:inclusion => IP_ADDRESS
  validates :hub,:inclusion => HUB
  validates :dns_server,:inclusion => DNS_SERVER
  validates :windows_domain,:inclusion => WINDOWS_DOMAIN
  validates :network_connection,:inclusion => NETWORK_CONNECTION
  validates :physical_keep,:inclusion => PHYSICAL_KEEP
  validates :port_listen,:inclusion => PORT_LISTEN
  validates :network_inside,:inclusion => NETWORK_INSIDE

  has_and_belongs_to_many :products

  %w(ip_address hub dns_server windows_domain network_connection physical_keep port_listen network_inside).each do |m_name|
    define_method m_name do
      self[m_name] || '不知道'
    end
  end
end
