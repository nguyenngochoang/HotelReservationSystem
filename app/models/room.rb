class Room < ApplicationRecord
  extend Enumerize

  enumerize :room_type, in: %i[single double family]
end
