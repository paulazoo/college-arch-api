class Mentee < ApplicationRecord
  has_one :user, :as => :account

  has_one :mentors_mentee, dependent: :destroy
  has_one :mentor, through: :mentors_mentee

end
