require_relative '../lib/active_record_lite'

# SQLObject is akin to ActiveRecord::Base

class Reservation < SQLObject
  belongs_to :restaurant
  belongs_to :user
end
