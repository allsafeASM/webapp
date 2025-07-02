class EnumerationScan < ApplicationRecord
  belongs_to :domain
  belongs_to :user

  has_many :enumeration_scan_results, dependent: :destroy

  before_validation :set_user_from_domain, on: :create

  broadcasts_to :domain

  private

  def set_user_from_domain
    self.user ||= domain&.user
  end
end
