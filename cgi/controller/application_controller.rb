require 'erb'
require 'cgi'
require 'cgi/session'

class ApplicationController
  attr_accessor :cgi, :session, :params, :controller, :action

  def initialize
    @cgi = CGI.new
    find_session
    @params = @cgi.params
    @render_once = true
    params_parse
    @controller = Application.get_controller_and_action_name[:controller]
    @action = Application.get_controller_and_action_name[:action]
  end

  def find_session
    begin
      request_cookies = (ENV["HTTP_COOKIE"] || "").split(";").map(&:strip).grep(/^_session_id/)
      session_id = request_cookies[0].split("=")[1] unless request_cookies.empty?
      option = {"new_session" => false}
      option["session_id"] = session_id if session_id
      @session = CGI::Session.new(@cgi, option)
    rescue ArgumentError
      @session = CGI::Session.new(cgi, "new_session" => true)
    end
  end

  def params_parse
    if @params != nil
      form_array = @params.map do |key, value|
        if value.size == 1 && value.kind_of?(Array)
          [key.to_sym, value.first]
        else
          [key.to_sym, value]
        end
       end.flatten(1)
    end
    @params = Hash[*form_array]
  end

  def redirect_to(url, status="REDIRECT")
    print @cgi.header( {
      "status"     => status,
      "Location"   => url
    })
  end

  def render(viewfile=nil)
    if @render_once
      viewfile ||= "view/#{@controller}/#{@action}.html.erb"
      @cgi.out(){
        ERB.new(File.read(viewfile)).result(binding)
      }
      @render_once = false
    end
  end
end
