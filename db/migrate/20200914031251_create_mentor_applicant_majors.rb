class CreateMentorApplicantMajors < ActiveRecord::Migration[6.0]
  def change
    create_table :mentor_applicant_majors do |t|

      t.timestamps
      t.references(:mentor_applicant, null: false, foreign_key: true)
      t.string(:major)
    end
  end
end
