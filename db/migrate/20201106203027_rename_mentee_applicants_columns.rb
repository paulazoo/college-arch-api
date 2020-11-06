class RenameMenteeApplicantsColumns < ActiveRecord::Migration[6.0]
  def change
    rename_column(:mentee_applicants, :asian, :asian_pi)
    rename_column(:mentor_applicants, :asian, :asian_pi)
    add_column(:mentee_applicants, :me_na, :boolean, default: false)
  end
end
