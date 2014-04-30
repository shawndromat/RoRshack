require 'erb'
require 'active_support/inflector'
require_relative 'params'
require_relative 'session'

module UrlHelper
  def method_missing(method_name, arg = nil)
    class_name = self.class.to_s[0..-11].downcase
    method_name = method_name.to_s.downcase
    if method_name.end_with?("_path")
      string = method_name[0..-6]
      if arg == nil
        return "/#{class_name.pluralize}" if string == class_name.pluralize
        return "/#{class_name.pluralize}/new" if string == "new_#{class_name}"
      elsif arg.is_a? Integer
        return "/#{class_name.pluralize}/#{arg}" if string == class_name
        return "/#{class_name.pluralize}/#{arg}/edit" if string == "edit_#{class_name}"
      end
    elsif method_name.end_with?("_url")
      string = method_name[0..-5]
      prefix = "http://localhost:8080"
      if arg == nil
        return "#{prefix}/#{class_name.pluralize}" if string == class_name.pluralize
        return "#{prefix}/#{class_name.pluralize}/new" if string == "new_#{class_name}"
      elsif arg.is_a? Integer
        return "#{prefix}/#{class_name.pluralize}/#{arg}" if string == class_name
        return "#{prefix}/#{class_name.pluralize}/#{arg}/edit" if string == "edit_#{class_name}"
      end
    end
  end
end


class ControllerBase
  include UrlHelper
  attr_reader :req, :res, :params

  # setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    raise "already rendered" if already_built_response?
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
    raise "already rendered" if already_built_response?
    res.status = 302
    res["Location"] = url
    @already_built_response = true
    session.store_session(@res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    class_name = self.class.to_s[0..-11].pluralize.underscore
    f = File.read("views/#{class_name}_controller/#{template_name}.html.erb")
    template = ERB.new(f)
    b = binding()
    render_content(template.result(b), 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    render(name.to_s) unless @already_built_response
  end
end


