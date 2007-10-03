class Institutiontitle < ActiveRecord::Base
  validates_presence_of :name
  validates_numericality_of :id, :allow_nil => true, :only_integer => true

  validates_uniqueness_of :name
  has_many :institutions
end

