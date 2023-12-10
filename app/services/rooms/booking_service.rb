module Rooms
  class BookingService
    def initialize(number_of_guests: )
      @number_of_guests = number_of_guests
      @rooms = Room.all.order(sleeps: :desc).to_a
      @final_result = []
      @option_no = 0
    end

    def self.call(number_of_guests:)
      new(number_of_guests: number_of_guests).room_booking
    end

    def find_booking_options
      options = []
      (1..rooms.size).each do |n|
        combinations = rooms.repeated_combination(n).to_a
        combinations.select! do |c|
          total_sleeps = c.map(&:sleeps).sum
          total_sleeps == number_of_guests
        end
        next if combinations.empty?

        inspect_options(combinations)
        best_combination = min_by_price(combinations)
        options << best_combination
      end
      options
    end

    def min_by_price(options)
      options.min_by do |c|
        c.map(&:price).sum
      end
    end

    def inspect_options(combinations)
      combinations.each_with_index do |option, index|
        @option_no += 1
        puts "Option #{@option_no}:"
        option.each do |room|
          puts "Room type: #{room.room_type}, Sleeps: #{room.sleeps}, Price: $#{room.price}"
        end
        total_price = option.map(&:price).sum
        puts "Total price: $#{total_price}"
      end
    end

    def room_booking
      cheapest_options = min_by_price(find_booking_options)

      cheapest_options.reduce(["", 0]) do |acc, room|
        acc[0] += "#{room.room_type} " unless acc[0].include?(room.room_type)
        acc[1] += room.price
        acc
      end.join(" - ")
    end


    private

    attr_reader :number_of_guests, :rooms, :final_result, :combinations
  end
end
