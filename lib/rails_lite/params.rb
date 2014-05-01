require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @params = deep_merge(route_params, get_query_params(req))
    @params = deep_merge(@params, get_body_params(req))
    @permitted = []
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
    keys.each { |key| @permitted << key}
    @temp.select{ |key| @permitted.include?(key) }
  end

  def require(key)
    raise AttributeNotFoundError unless @params.keys.include?(key)
    @temp = @params[key]
    self
  end

  def permitted?(key)
    @permitted.include?(key)
  end

  def to_s
    @params.to_json
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
  
  def get_query_params(req)
    return {} if req.query_string == nil
    parse_www_encoded_form(req.query_string)
  end
  
  def get_body_params(req)
    return {} if req.body == nil
    parse_www_encoded_form(req.body)
  end
  
  def parse_www_encoded_form(www_encoded_form)
    decoded_params = {}
    decoded = URI.decode_www_form(www_encoded_form)
    decoded.each do |query|
      hash = {}
      key = parse_key(query.first)
      value = query.last
      if key.is_a?(Array)
        keys = parse_key(query.first)
        hash = keys.reverse.inject(value) { |accum, key| {key => accum} }
      else
        hash[query.first] = value
      end
      deep_merge(decoded_params, hash)
    end
    decoded_params
  end

  def parse_key(key)
    subbed = key.gsub(/[\[\]]/, " ")
    subbed.split
  end

  def deep_merge(h1, h2)
    if h1.keys.none?{ |key| h2.keys.include?(key)}
      return h1.merge!(h2)
    else
      h1.keys.each do |key1|
        if h2.keys.include?(key1)
          deep_merge(h1[key1], h2[key1])
        end
      end
    end
    return h1
  end
end
