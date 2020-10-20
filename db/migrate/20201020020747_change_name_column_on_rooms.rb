class ChangeNameColumnOnRooms < ActiveRecord::Migration[6.0]
  def change
    change_column_null :rooms, :name, false
  end
end
