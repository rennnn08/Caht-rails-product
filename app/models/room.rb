class Room < ApplicationRecord
  has_many :user_belongs_rooms, dependent: :destroy
  has_many :users, through: :user_belongs_rooms, dependent: :destroy
  has_many :messages, dependent: :destroy

end
