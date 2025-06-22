class EnumerationScan < ApplicationRecord
  belongs_to :domain
  belongs_to :user

  has_many :enumeration_scan_results, dependent: :destroy
end
