# encoding: utf-8
ActiveAdmin.register Document, :as => 'AnnualReport' do
  menu :label => 'Informes anuales enviados', :priority => 4

  controller do
    def scoped_collection
      Document.annual_reports
    end
  end

  member_action :unlock, method: :get do
    resource.unlock!
    redirect_to collection_path, notice: "Envío activado!"
  end

  index :title => 'Informes anuales enviados' do
    column(:id) { |record| record.id }
    column(:fullname) { |record| record.user.fullname_or_email }
    column(:adscription) { |record| record.user.adscription_name record.user.id,record.documenttype.year }
    column(:category_name) { |record| record.user.category_name }
    column(:worker_key) { |record| record.user.worker_key_or_login }
    column(:document_type) { |record| record.documenttype.name }
    column(:document_type_year) { |record| record.documenttype.year }
    column(:document_achievements) { |record|
      doc = AnnualReport.where(:user_id => record.user_id, :documenttype_id => record.documenttype_id).first
      s = doc.nil? ? '-' : doc.body
      truncate(s, :length => 25)
    }
    column(:approved) { |record| record.approved? ? 'Sí' : 'No' }
    column(:approved_by) { |record| record.approved_by_fullname }
    column(:comments) { |record|
      s = record.comments
      truncate(s, :length => 25)
    }
    column(:ip_address) { |record| record.ip_address }
    column 'Download', :sortable => false do |record|
      link_to 'Descargar', record.url, :target => '_blank'
    end
    column "Activar" do |record|
      link_to 'Activar envío', unlock_admin_annual_report_path(record), :confirm => '¿Estás seguro que deseas activar el envío de este documento?'
    end
  end

  filter :year, :collection => (Date.today.year - 100 .. Date.today.year + 1).to_a.reverse, :label => 'Año', :as => :select
  filter :adscription_id_eq, :collection => proc { Adscription.enabled }, :label => 'Adscripción', :as => :select
  filter :user, :label => 'Académico'
  filter :approved

  csv do
    column(:fullname) { |record| record.user.fullname_or_email }
    column(:adscription) { |record| record.user.adscription_name record.user.id,record.documenttype.year }
    column(:category_name) { |record| record.user.category_name }
    column(:worker_key) { |record| record.user.worker_key_or_login }

    column(:document_type) { |record| record.documenttype.name }
    column(:document_type_year) { |record| record.documenttype.year }
    column(:document_achievements) { |record|
      doc = AnnualReport.where(:user_id => record.user_id, :documenttype_id => record.documenttype_id).first
      doc.nil? ? '-' : doc.body
    }
    column(:approved) { |record| record.approved? ? 'Sí' : 'No' }
    column(:approved_by) { |record| record.approved_by_fullname }
    column(:comments) { |record| record.comments }
    column(:ip_address) { |record| record.ip_address }
  end
end
