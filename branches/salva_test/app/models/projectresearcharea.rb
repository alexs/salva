class Projectresearcharea < ActiveRecord::Base
  validates_presence_of :project_id, :researcharea_id

  validates_numericality_of :id, :allow_nil => true, :only_integer => true
  validates_numericality_of :project_id, :allow_nil => true, :only_integer => true
  validates_numericality_of :researcharea_id, :allow_nil => true, :only_integer => true

  validates_uniqueness_of :project_id, :scope => [:researcharea_id]

  belongs_to :project
  belongs_to :researcharea
end
