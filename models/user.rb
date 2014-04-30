require_relative '../lib/active_record_lite'

class User < SQLObject
  has_many :reservations
end