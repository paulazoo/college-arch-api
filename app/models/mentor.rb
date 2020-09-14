class Mentor < ApplicationRecord
  has_one :user, :as => :account

  has_many :mentors_mentees, dependent: :destroy
  has_many :mentees, -> { distinct }, through: :mentors_mentees

end
