require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @already_built_response = false
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    raise "Response already built" if already_built_response?
    self.res.status = 302
    self.res.header['location'] = url
    @already_built_response = true
    session.store_session(res)
  end

  def render_content(content, content_type)
    raise "Response already built" if already_built_response?
    self.res.content_type = content_type
    self.res.body = content
    @already_built_response = true
    session.store_session(res)
  end

  def render(template_name)
    file_content = File.read(
      "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
      )

    erb_template = ERB.new(file_content)

    render_content(erb_template.result(binding), "text/html")
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    send(name)
    render(name) unless already_built_response?
  end
end
