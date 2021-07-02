class Multimentees < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentor_applicants, :multi_mentees, :integer, default: 1)
  end
end
