module Rooms
  class BookingService
    def initialize(number_of_guests: )
      @number_of_guests = number_of_guests
      @rooms = Room.all.order(sleeps: :desc).to_a
      @final_result = []
    end

    def self.call(number_of_guests:)
      new(number_of_guests: number_of_guests).find_options(start: 0, remaining_guests: number_of_guests, result: {})
    end

    def find_options(start:, remaining_guests:, result:)
      maximum_capacity = rooms[start..].sum{|x| x.sleeps * x.number_of_rooms}
      return "No option" if remaining_guests > maximum_capacity

      if start >= rooms.size
        final_result << result
        return;
      end

      if remaining_guests <= 0
        final_result << result
        find_options(start: start, remaining_guests: number_of_guests, result: {})
      else
        rooms[start..].each do |room|
          next if room.sleeps > remaining_guests
          result[room] = 0
          while remaining_guests >= room.sleeps && result[room] < room.sleeps * room.number_of_rooms
            result[room] += 1
            remaining_guests -= room.sleeps
          end
        end
        find_options(start: start + 1, remaining_guests: remaining_guests, result: result)
      end

      cheapest_option = final_result.min_by do |x|
        x.sum{|key,value| key.price * value}
      end

      total_money = cheapest_option.sum{|key, value| key.price * value}
      cheapest_option.keys.map(&:room_type_text).join(" ") + " - $#{total_money}"
    end

    private

    attr_reader :number_of_guests, :rooms, :final_result
  end
end
