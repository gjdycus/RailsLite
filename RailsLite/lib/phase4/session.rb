require 'json'
require 'webrick'
require 'byebug'
module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
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

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie = WEBrick::Cookie.new('_rails_lite_app', @req_cookie_value.to_json)
      res.cookies << cookie
    end
  end
end
