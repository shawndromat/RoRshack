require_relative '../lib/active_record_lite'

class User < SQLObject
  attr_accessor :fname, :lname
  has_many :reservations
end