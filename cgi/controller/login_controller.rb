require 'json'

class LoginController < ApplicationController
  def index
  end

  def auth
    username = @params[:username]
    resp = DoscaAPI.auth(username, @params[:password], @params[:email])
    if has_error?(resp)
      @error_message = resp[:message]
    else
      @session["username"] = username
      user_info =  resp
      user_info[:contents].each{|contents| 
        resp = DoscaAPI.categories(user_info[:client_code], user_info[:mail], contents[:code])
        user_info[:categories] ||= {}
        user_info[:categories][contents[:code].to_sym] = resp[:categories]
        resp = DoscaAPI.ports(user_info[:client_code], user_info[:mail], contents[:code])
        user_info[:ports] ||= {}
        user_info[:ports][contents[:code].to_sym] = resp[:ports]
      }

      #save the json into session 
      @session[username] = user_info.to_json
      default_contents = user_info[:contents].select{|h| h[:no] == "0"}.first
      forward_action = "news"
      forward_action = "past" if default_contents[:code].index("PAST")
      redirect_to @root_uri + "/edit" + "/" + forward_action
    end
  end
end
