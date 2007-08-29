class Inproceeding < ActiveRecord::Base
  validates_presence_of :proceeding_id, :title, :authors

  validates_numericality_of :id, :allow_nil => true, :only_integer => true
  validates_numericality_of :proceeding_id, :allow_nil => true, :only_integer => true
  validates_uniqueness_of :title, :scope => [:proceeding_id]

  belongs_to :proceeding
  has_many :user_inproceeding
end
