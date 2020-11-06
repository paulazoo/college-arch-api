class AddUsLiving < ActiveRecord::Migration[6.0]
  def change
    add_column(:mentee_applicants, :us_living, :boolean, default: true)
  end
end
