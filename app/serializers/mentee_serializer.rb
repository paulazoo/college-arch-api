class MenteeSerializer < ActiveModel::Serializer
  attributes :id, :classroom

  has_one :user
end
