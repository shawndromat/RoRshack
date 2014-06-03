require_relative '../lib/active_record_lite'

# SQLObject is akin to ActiveRecord::Base

class Restaurant < SQLObject
  belongs_to :chef, class_name: "User", foreign_key: :chef_id
end
