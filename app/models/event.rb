class Event < ApplicationRecord
  attr_accessor :current_account

  enum kind: { open: 0, fellows_only: 1, invite_only: 2 }
  
  has_many :invitations, class_name: 'Invitation', foreign_key: 'event_id', dependent: :destroy

  has_many :registrations, class_name: 'Registration', foreign_key: 'event_id', dependent: :destroy

  validates_presence_of :name

  def account_registration(account = nil)
    account ||= current_account
    @account_registration = registrations.where(account: account).first
  end

end
