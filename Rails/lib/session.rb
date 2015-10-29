require 'json'
require 'webrick'

class Session
  def initialize(req)
    @req_cookie_value = {}
    req.cookies.each do |cookie|
      if cookie.name == "_rails_lite_app"
        @req_cookie_value = JSON.parse(cookie.value)
        break
      end
    end
  end

  def [](key)
    @req_cookie_value[key.to_s]
  end

  def []=(key, val)
    @req_cookie_value[key.to_s] = val
  end

  def store_session(res)
    cookie = WEBrick::Cookie.new('_rails_lite_app', @req_cookie_value.to_json)
    res.cookies << cookie
  end
end
