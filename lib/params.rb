require 'uri'

class Params
  def initialize(req, route_params = {})
    @params = route_params
    parse_www_encoded_form(req.query_string) unless req.query_string.nil?
    parse_www_encoded_form(req.body) unless req.body.nil?
  end

  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private

  def parse_www_encoded_form(www_encoded_form)
    params = {}
    URI::decode_www_form(www_encoded_form).each do |pair|
      scope = params
      keys = parse_key(pair[0])
      keys.each_with_index do |key, index|
        if index == keys.length - 1
          scope[key] = pair[1]
        else
          scope[key] ||= {}
          scope = scope[key]
        end
      end
    end
    @params.merge! params
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
