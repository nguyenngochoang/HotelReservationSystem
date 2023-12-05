# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

ROOM_MAPPING = {
  single: {
    sleeps: 1,
    number_of_rooms: 2,
    price: 30
  },
  double: {
    sleeps: 2,
    number_of_rooms: 3,
    price: 50
  },
  family: {
    sleeps: 4,
    number_of_rooms: 1,
    price: 85
  },
}

Room.room_type.values.each do |room_type|
  Room.find_or_create_by!(
    room_type:,
    **ROOM_MAPPING[room_type.to_sym]
  )
end
