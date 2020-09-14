class CreateMentorApplicantInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :mentor_applicant_interests do |t|

      t.timestamps
      t.references(:mentor_applicant, null: false, foreign_key: true)
      t.string(:interest)
    end
  end
end
