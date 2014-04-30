require_relative '../lib/active_record_lite'

class Reservation < SQLObject
  belongs_to :restaurant
  belongs_to :user
end