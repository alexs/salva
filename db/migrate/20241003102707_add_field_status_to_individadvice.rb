class AddFieldStatusToIndividAdvice < ActiveRecord::Migration
  def change
    add_column :indivadvices, :status_id, :integer
  end
end
