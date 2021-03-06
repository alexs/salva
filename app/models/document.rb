class Document < ActiveRecord::Base
  validates_numericality_of :id, :allow_nil => true, :greater_than => 0, :only_integer => true
  validates_uniqueness_of :documenttype_id, :scope => [:user_id]
  belongs_to :user
  belongs_to :documenttype
  belongs_to :document_type
  belongs_to :approved_by, :class_name => 'User'

  attr_accessible :user_id, :ip_address, :documenttype_id, :file, :approved_by_id, :document_type_id
  attr_accessible :comments, :as => :academic

  scope :sort_by_documenttype, :order => 'documenttypes.start_date DESC, documenttypes.end_date DESC', :joins => [:documenttype], :readonly => false
  scope :fullname_asc, joins(:user=>:person).order('people.lastname1 ASC, people.lastname2 ASC, people.firstname ASC').sort_by_documenttype
  scope :annual_reports, joins(:documenttype).where("documenttypes.name LIKE 'Informe anual de actividades%'").sort_by_documenttype
  scope :annual_plans, joins(:documenttype).where("documenttypes.name LIKE 'Plan de trabajo%'").sort_by_documenttype

  scope :fullname_like, lambda { |fullname|
    person_fullname_like_sql = Person.find_by_fullname(fullname).select('user_id').to_sql
    sql = "documents.user_id IN (#{person_fullname_like_sql})"
    where(sql)
  }
  scope :login_like, lambda { |login| joins(:user).where(:user => { :login.matches => "%#{login.downcase}%" }) }
  scope :adscription_id_eq, lambda { |adscription_id| joins(:user=> :user_adscriptions).where(["user_adscriptions.adscription_id = ?", adscription_id] ) }
  scope :jobpositioncategory_id_eq, lambda { |category_id| joins(:user=> :jobpositions).where(["jobpositions.jobpositioncategory_id = ?", category_id] ) }
  scope :is_not_hidden, where("is_hidden != 't' OR is_hidden IS NULL")
  scope :year_eq, lambda { |y|
    joins(:documenttype).where("documenttypes.year = ?", y)
  }

  search_methods :fullname_like, :login_like, :adscription_id_eq,
    :jobpositioncategory_id_eq, :year_eq

  before_create :file_path

  def self.paginated_search(params)
    is_not_hidden.fullname_asc.search(params[:search]).page(params[:page] || 1).per(params[:per_page] || 20)
  end

  def url
   File.expand_path(file_path).gsub(File.expand_path(Rails.root.to_s+'/public'), '')
  end

  def file_path
    if document_type_id.nil?
    path = Rails.root.to_s + '/public/uploads'
    if !documenttype.name.match(/^Informe anual de actividades/).nil?
      path += '/annual_reports/' + documenttype.year.to_s
    elsif !documenttype.name.match(/^Plan de trabajo/).nil?
      path += '/annual_plans/' + documenttype.year.to_s
    end
    system "mkdir -p #{path}" unless File.exist? path

    unless user.nil?
      self.file = path + "/#{user.login}.pdf"
    else
      self.file.to_s
    end
    end
  end

  def approve
    update_attribute(:approved, true)
  end

  def reject
    update_attribute(:approved, false)
  end

  def approved_by_fullname
    approved_by.fullname_or_email unless approved_by_id.nil?
  end

  def unlock!
    doc = AnnualPlan.where(:user_id => user_id, :documenttype_id => documenttype_id).first
    doc.update_attribute(:delivered, false) unless doc.nil?
    update_attribute(:approved, false)
  end
end
