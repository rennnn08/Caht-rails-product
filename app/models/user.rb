class User < ApplicationRecord
  has_secure_password
  has_many :user_belongs_rooms, dependent: :destroy
  has_many :rooms, through: :user_belongs_rooms
  has_many :messages

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end

end
