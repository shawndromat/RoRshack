require 'json'
require 'webrick'

class Session
  attr_accessor :contents
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    @req = req
    @contents = {}
    @req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @contents = JSON.parse(cookie.value)
      end
    end    
  end

  def [](key)
    @contents[key]
  end

  def []=(key, val)
    @contents[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @contents.to_json )
  end
end
