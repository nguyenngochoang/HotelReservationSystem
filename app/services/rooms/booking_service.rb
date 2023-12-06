module Rooms
  class BookingService
    def initialize(number_of_guests: )
      @number_of_guests = number_of_guests
      @rooms = Room.all.order(sleeps: :desc).to_a
      @final_result = []
      # @combinations = find_combinations
    end

    def self.call(number_of_guests:)
      new(number_of_guests: number_of_guests).room_booking
    end

    def room_booking
      find_options(start: 0, remaining_guests: number_of_guests, result: {})

      final_result.each_with_index do |result, index|
        puts "Option #{index + 1}:"
        room_name = ""
        total_money = 0

        result.each do |key, value|
          room_name += key.room_type_text + " "
          total_money += key.price * value
        end
        puts "#{room_name} - #{total_money}"
      end

      room_name = ""
      total_money = 0

      cheapest_option = final_result.min_by do |x|
        x.sum{|key,value| key.price * value}
      end

      cheapest_option.each do |key, value|
        room_name += key.room_type_text + " "
        total_money += key.price * value
      end

      "#{room_name} - #{total_money}"
    end


    def find_options(start:, remaining_guests:, result:)
      return if start >= rooms.size

      maximum_capacity = rooms[start..].sum{|x| x.sleeps * x.number_of_rooms}
      return "No option" if remaining_guests > maximum_capacity

      rooms[start..].each do |room|
        next if room.sleeps > remaining_guests

        result[room] = 0
        while remaining_guests >= room.sleeps && result[room] < room.sleeps * room.number_of_rooms
          result[room] += 1
          remaining_guests -= room.sleeps
        end
      end

      if remaining_guests <= 0
        final_result << result unless final_result.include?(result)
        find_options(start: start + 1, remaining_guests: number_of_guests, result: {})
      else
        find_options(start: start + 1, remaining_guests: remaining_guests, result: result)
      end
      final_result
    end

    private

    attr_reader :number_of_guests, :rooms, :final_result, :combinations
  end
end
