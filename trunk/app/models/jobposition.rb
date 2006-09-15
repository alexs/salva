class Jobposition < ActiveRecord::Base
validates_presence_of :institution_id, :startyear
validates_numericality_of :institution_id #:jobpositioncategory_id, :contracttype_id, 
belongs_to :jobpositioncategory
belongs_to :contracttype
belongs_to :institution
end
