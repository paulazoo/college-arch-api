class CreateMentorApplicantMajors < ActiveRecord::Migration[6.0]
  def change
    create_table :mentor_applicant_majors do |t|

      t.timestamps
    end
  end
end
