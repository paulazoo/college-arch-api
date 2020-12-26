class AddUndoc < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :undoc, :boolean, default: false)
    add_column(:mentor_applicants, :undoc, :boolean, default: false)
  end
end
