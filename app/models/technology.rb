class Technology < ApplicationRecord
  # Many-to-many relationship with Webserver through WebserversTechnology
  has_many :webservers_technologies, dependent: :destroy
  has_many :webservers, through: :webservers_technologies
end
