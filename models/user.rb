require_relative '../lib/active_record_lite'

# SQLObject is akin to ActiveRecord::Base

class User < SQLObject
  # unfortunately no strong params yet
  attr_accessor :fname, :lname
  has_many :reservations
end
