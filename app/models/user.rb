class User < ApplicationRecord
  has_secure_password
  validates :email, :first_name, :last_name, :role, presence: true
  enum role: [:user, :admin]
  has_many :addresses


  def full_name
    "#{first_name}" + ' ' + "#{last_name}"
  end

  def full_address
    address = addresses.first
    "#{address.street_address}" + ' ' + 
    "#{address.city.name}" + ' ' + 
    "#{address.state.name}" + ' ' + 
    "#{address.zipcode.number}" 
  end
end