class CreateUserBelongsRooms < ActiveRecord::Migration[6.0]
  def change
    create_table :user_belongs_rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
