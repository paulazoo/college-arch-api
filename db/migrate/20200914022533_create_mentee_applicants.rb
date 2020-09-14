class CreateMenteeApplicants < ActiveRecord::Migration[6.0]
  def change
    create_table :mentee_applicants do |t|

      t.timestamps

      t.string(:first_name)
      t.string(:last_name)
      t.string(:school)
      t.integer(:us_citizen)
      t.string(:location)
      t.string(:phone)
      t.string(:email)
      t.string(:grad_year)
      t.string(:essay)

      # ethnicity
      t.boolean(:hispanic, default: false)
      t.boolean(:native, default: false)
      t.boolean(:asian, default: false)
      t.boolean(:black, default: false)
      t.boolean(:multiracial, default: false)
      t.boolean(:other, default: false)

      # other languages
      t.boolean(:spanish, default: false)
      t.boolean(:portuguese, default: false)
      t.boolean(:mandarin, default: false)
      t.boolean(:cantonese, default: false)
      t.boolean(:french, default: false)
      t.boolean(:hindi, default: false)
      t.boolean(:arabic, default: false)

      # disadvantaged background?
      t.boolean(:low_income, default: false)
      t.boolean(:first_gen, default: false)
      t.boolean(:stem_girl, default: false)
      t.boolean(:immigrant, default: false)
    end
  end
end
