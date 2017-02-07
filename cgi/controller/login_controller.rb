class LoginController < ApplicationController
  def index
  end

  def auth
    username = @params[:username]
    resp = DoscaAPI.auth(username, @params[:password], @params[:email])
    if has_error(resp)
      @error_message = resp[:message]
    else
      user_info = @session[username.to_sym] = resp
      user_info[:contents].each{|contents| 
        resp = DoscaAPI.categories(user_info[:client_code], user_info[:mail], contents[:code])
        user_info[:categories] ||= {}
        user_info[:categories][contents[:code].to_sym] = resp[:categories] || {}
        resp = DoscaAPI.ports(user_info[:client_code], user_info[:mail], contents[:code])
        user_info[:ports] ||= {}
        user_info[:ports][contents[:code].to_sym] = resp[:ports] || {}
      }
      redirect_to Settings._settings[:server][:root_uri] + "/edit"
    end
  end
end
