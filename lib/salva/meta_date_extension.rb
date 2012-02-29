# This module extends the models with attributes: year and month, or
# startyear, startmonth, endyear and endmonth.
#
# Class methods: since and until
# Instance methods: date or start_date and end_date
module MetaDateExtension
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def inherited(subclass)
      super
      if subclass.column_names.include? 'year' and subclass.column_names.include? 'month'
        subclass.send :include, MetaDateExtension::SimpleDateMethods
        subclass.class_eval do
          simple_date_scopes
        end
      elsif (subclass.column_names & ['startyear', 'startmonth', 'endyear', 'endmonth']).size == 4
        subclass.send :include, MetaDateExtension::StartEndDateMethods
        subclass.class_eval do
          start_end_date_scopes
        end
      elsif subclass.column_names.include? 'start_date' and subclass.column_names.include? 'end_date'
        subclass.send :include, MetaDateExtension::DateRangeMethods
        subclass.class_eval do
          date_range_scopes
        end
      elsif subclass.column_names.include? 'year' and !subclass.column_names.include? 'month'
        subclass.class_eval do
          only_year_scopes
        end
      end
    end

    protected

    def start_end_date_scopes
       scope :since, lambda { |year, month| where{{:startyear.gteq => year} & {:startmonth.gteq => month}} } unless respond_to? :since
       scope :until, lambda { |year, month| where{{:endyear.lteq => year} & {:endmonth.lteq => month}} } unless respond_to? :until
       date_search_methods
    end

    def simple_date_scopes
      scope :since, lambda { |year, month| where{{:year.gteq => year} & {:month.gteq => month}} } unless respond_to? :since
      scope :until, lambda { |year, month| where{{:year.lteq => year} & {:month.lteq => month}} } unless respond_to? :until
      date_search_methods
    end

    def date_range_scopes
      scope :since, lambda { |date| where{{:start_date.gteq => date}} } unless respond_to? :since
      scope :until, lambda { |date| where{{:end_date.lteq => date}} } unless respond_to? :until
      search_methods :since, :until
      unless respond_to? :among
        scope :among, lambda { |start_date, end_date| where{ ({:start_date.gteq => start_date}) | ({:end_date.lteq => end_date}) } }
        search_methods :among, :splat_param => true, :type => [:date, :date]
      end
    end

    def only_year_scopes
      scope :since, lambda { |year| where{{:year.gteq => year}} } unless respond_to? :since
      scope :until, lambda { |year| where{{:year.lteq => year}} } unless respond_to? :until
      search_methods :since, :until
      unless respond_to? :among
        scope :among, lambda { |start_year, end_year| since(start_year).until(end_year)}
        search_methods :among, :splat_param => true, :type => [:integer, :integer]
      end
    end

    def date_search_methods
      search_methods :since, :splat_param => true, :type => [:integer, :integer] if respond_to? :since
      search_methods :until, :splat_param => true, :type => [:integer, :integer] if respond_to? :until
    end
  end

  module DateMethods
    protected
    def localize_date(year, month, format=:month_and_year)
      if year.to_i > 0 and (month.to_i > 0 and month.to_i <= 12)
        I18n.localize(Date.new(year, month, 1), :format => format)
      elsif !year.nil?
        year
      end
    end
  end

  module StartEndDateMethods
    include MetaDateExtension::DateMethods

    def start_date
      I18n.t(:start_date) + ': ' + localize_date(startyear, startmonth).to_s  if !startyear.nil? or !startmonth.nil?
    end

    def end_date
      I18n.t(:end_date) + ': ' + localize_date(endyear, endmonth).to_s if !endyear.nil? or !endmonth.nil?
    end
  end

  module SimpleDateMethods
    include MetaDateExtension::DateMethods

    def date
      localize_date(year, month)
    end
  end

  module DateRangeMethods
    def start_date
      if attributes['start_date'].is_a? Date
        I18n.t(:start_date) + ': ' +  I18n.localize(attributes['start_date'], :format => :long_without_day)
      end
    end

    def end_date
      if attributes['end_date'].is_a? Date
        I18n.t(:end_date) + ': ' +  I18n.localize(attributes['end_date'], :format => :long_without_day)
      end
    end
  end
end

ActiveRecord::Base.send :include, MetaDateExtension
