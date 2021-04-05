class AddApplicantPasswords < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :applicant_password, :string)
    add_column(:mentor_applicants, :applicant_password, :string)
    add_column(:mentee_applicants, :applicant_status, :integer, default: 0)
    add_column(:mentor_applicants, :applicant_status, :integer, default: 0)
  end
end
