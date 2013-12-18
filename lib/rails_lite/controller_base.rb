require 'active_support/core_ext'
require 'erb'
require_relative 'params'
require_relative 'session'

class ControllerBase
  attr_reader :params

  # setup the controller
  def initialize(req, res, route_params = {})
    @req, @res = req, res
  end

  # populate the response with content
  # set the responses content type to the given type
  # later raise an error if the developer tries to double render
  def render_content(content, type)
    unless already_rendered?
      @res.body, @res.content_type, @already_built_response = content, type, true
    end
  end

  # helper method to alias @already_rendered
  def already_rendered?
    @already_built_response
  end

  # set the response status code and header
  def redirect_to(url)
    unless already_rendered?
      @res.status = 302
      p @res.header["location"] = url
      @already_built_response = true
    end
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    controller_name = self.class.name.underscore
    file_contents =
      File.read("views/#{controller_name}/#{template_name}.html.erb")

    template = ERB.new(file_contents).result(binding)
    render_content(template, 'text/text')
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end