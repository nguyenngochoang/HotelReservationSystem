class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :room_type
      t.integer :sleeps
      t.integer :number_of_rooms
      t.integer :price

      t.timestamps
    end
  end
end
