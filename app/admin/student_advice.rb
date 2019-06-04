# encoding: utf-8
ActiveAdmin.register Indivadvice, :as => 'StudentAdvice' do
  menu :parent => 'Docencia', :label => 'Asesoría a estudiantes'

  controller do
    def scoped_collection
      Indivadvice.students
    end
  end

  controller do
    def index
      if params.has_key? :q and params[:q].has_key? :among and !params[:q][:among].is_a? Array
        params[:q][:among] = params[:q][:among].split(',').collect(&:to_i)
      end
      index!
    end
  end

  index :title => 'Asesoría a estudiantes' do
    column :id

    column :indivname
    column :hours
    column(:indivadvicetarget) { |record| record.indivadvicetarget.name}
    column :startyear
    column :startmonth
    column :endyear
    column :endmonth
    column(:degree) { |record| record.degree.nil? ? nil : record.degree.name }
    column(:career) { |record| record.career.nil? ? nil : record.career.name }
    column(:faculty) { |record| record.institution.nil? ? nil : record.institution.name }
    column(:university) { |record| record.university.nil? ? nil : record.university.name }
    column(:country) { |record| record.country.nil? ? nil : record.country.name }
    column(:fullname) { |record| record.user.fullname_or_email }
    column(:adscription) { |record| record.user.adscription_name record.user.id,record.startyear }
    column(:worker_key) { |record| record.user.worker_key_or_login }
  end

  filter :indivname
  filter :user, :label => 'Académico'
  filter :among, :collection => (Date.today.year - 100 .. Date.today.year + 1).to_a.reverse.collect {|y| [y, [y,1, y, 12].join(',') ]}, :label => 'Año', :as => :select
  filter :degree_id, :collection => proc { Degree.universitary }, :label => 'Grado', :as => :select
  filter :adscription_id, :collection => proc { Adscription.enabled }, :label => 'Adscripción', :as => :select

  csv do
    column :indivname
    column :hours
    column(:indivadvicetarget) { |record| record.indivadvicetarget.name}
    column :startyear
    column :startmonth
    column :endyear
    column :endmonth
    column(:degree) { |record| record.degree.nil? ? nil : record.degree.name }
    column(:career) { |record| record.career.nil? ? nil : record.career.name }
    column(:faculty) { |record| record.institution.nil? ? nil : record.institution.name }
    column(:university) { |record| record.university.nil? ? nil : record.university.name }
    column(:country) { |record| record.country.nil? ? nil : record.country.name }
    column(:fullname) { |record| record.user.fullname_or_email }
    column(:adscription) { |record| record.user.adscription_name record.user.id,record.startyear }
    column(:worker_key) { |record| record.user.worker_key_or_login }
  end
end
