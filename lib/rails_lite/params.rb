require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = {}
    parse_www_encoded_form(req.query_string) if req.query_string
    parse_www_encoded_form(req.body) if req.body
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def build_nested_param_hash(key_arr, value, hash)
    if key_arr.count == 1
      hash[key_arr.first] = value
      return hash
    end
    hash[key_arr.first] ||= {}
    build_nested_param_hash(key_arr[1..-1], value, hash[key_arr.first])
  end

  def parse_www_encoded_form(www_encoded_form)
    URI::decode_www_form(www_encoded_form).each do |pair|
      nested_key, value = pair
      key_arr = parse_key(nested_key)
      build_nested_param_hash(key_arr, value, @params)
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end