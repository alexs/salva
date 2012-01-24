class Adscription < ActiveRecord::Base
  validates_presence_of :name, :institution_id
  validates_numericality_of :id, :allow_nil => true, :greater_than => 0, :only_integer => true
  validates_numericality_of :institution_id, :greater_than => 0, :only_integer => true
  validates_uniqueness_of :name, :scope => [:institution_id]
  normalize_attributes :name, :abbrev

  belongs_to :institution
  has_many :user_adscriptions
  has_many :users, :through => :user_adscriptions, :source => :user, :uniq => true

  default_scope :order => 'name ASC'

  scope :enabled, where(:is_enabled => true)
  scope :not_enabled, where(:is_enabled => false)

  def users_to_xml
    users.collect {|record|
      {:fullname => record.fullname_or_login, :id => record.id, :login => record.login, :email => record.email }
    }.to_xml(:root => :users)
  end
end
