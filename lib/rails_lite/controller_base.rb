require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'



class ControllerBase
  attr_reader :params, :req, :res

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    res.content_type = type
    res.body = content
    session.store_session(@res)
    @already_built_response = true
  end

  # helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    res.status = 302
    res["Location"] = url
    @already_built_response = true
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    class_name = self.class.to_s.underscore
    f = File.read("views/#{class_name}/#{template_name}.html.erb")
    template = ERB.new(f)
    b = binding()
    render_content(template.result(b), 'html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.name
    render(name.to_s) unless @already_built_response
  end
end
