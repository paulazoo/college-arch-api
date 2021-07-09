class MoveApplicantsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column(:users, :interests, :string)

    add_column(:users, :backgrounds, :string)

    add_column(:users, :hobbies, :string)

    add_column(:users, :languages, :string)

    add_column(:users, :location, :string)

    add_column(:users, :city, :string)

    add_column(:users, :us_living, :boolean, default: true)

    add_column(:users, :essay, :string)

    add_column(:users, :extra_component, :string)
    
    add_column(:users, :multi_mentees, :integer, default: 1)

    add_column(:users, :status, :string, default: 'undecided')

  end
end
