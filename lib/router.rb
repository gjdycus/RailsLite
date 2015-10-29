require_relative 'route'

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    routes.each { |route| return route if route.matches?(req) }
    nil
  end

  def run(req, res)
    routes.each do |route|
      if match(req)
        route.run(req, res)
        return
      end
    end
    res.body = "Not Found"
    res.status = 404
  end
end
