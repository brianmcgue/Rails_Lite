require 'uri'

class Params
  def initialize(req, route_params = {})
    parse_www_encoded_form(req.query_string)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    @params = {}
    URI::decode_www_form(www_encoded_form).each do |pair|
      @params[pair.first] = pair.last
    end
  end

  def parse_key(key)
  end
end
