class UpdateMenteeApplicants < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :single_parent, :boolean, default: false)
    add_column(:mentee_applicants, :disabled, :boolean, default: false)
    add_column(:mentee_applicants, :lgbt, :boolean, default: false)
    rename_column(:mentee_applicants, :asian, :asian_pi)
    rename_column(:mentor_applicants, :asian, :asian_pi)
    add_column(:mentee_applicants, :me_na, :boolean, default: false)
    add_column(:mentee_applicants, :us_living, :boolean, default: true)
    add_column(:mentee_applicants, :city, :string)
  end
end
