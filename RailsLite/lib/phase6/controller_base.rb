require_relative '../phase5/controller_base'

module Phase6
  class ControllerBase < Phase5::ControllerBase
    attr_accessor :flash

    def initialize(req, res, route_params = {})
      super(req, res, route_params)
      @flash = Flash.new
    end
    # use this with the router to call action_name (:index, :show, :create...)
    def invoke_action(name)
      send(name)
      render(name) unless already_built_response?
    end
  end
end
