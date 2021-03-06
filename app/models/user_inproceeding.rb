class UserInproceeding < ActiveRecord::Base
  attr_accessible  :user_id, :ismainauthor, :inproceeding_id
  #validates_numericality_of :id, :allow_nil => true, :greater_than => 0, :only_integer => true
  #validates_inclusion_of :ismainauthor, :in => [true, false]
  #validates_uniqueness_of :inproceeding_id, :scope => [:user_id]

  belongs_to :inproceeding
  belongs_to :user

  scope :year_eq, lambda { |year| joins(:inproceeding => :proceeding).where('proceedings.year = ?', year) }
  scope :refereed, joins(:inproceeding => :proceeding).where("proceedings.isrefereed = 't' AND inproceedings.proceeding_id = proceedings.id")
  scope :unrefereed, joins(:inproceeding => :proceeding).where("proceedings.isrefereed = 'f' AND inproceedings.proceeding_id = proceedings.id")
  scope :conferencescope_id, lambda { |id| joins(:inproceeding => {:proceeding => :conference}).where('conferences.conferencescope_id = ?', id) }
  scope :adscription_id, lambda { |id| joins(:user => :user_adscription).where(:user => { :user_adscription => { :adscription_id => id} }) }

  search_methods :year_eq, :conferencescope_id, :adscription_id
end
