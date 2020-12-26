class AddAsianPis < ActiveRecord::Migration[6.0]
  def change
    rename_column(:mentee_applicants, :asian_pi, :asian)
    rename_column(:mentor_applicants, :asian_pi, :asian)
    add_column(:mentee_applicants, :pi, :boolean, default: false)
    add_column(:mentor_applicants, :pi, :boolean, default: false)
  end
end
