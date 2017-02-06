class LoginController < ApplicationController
  def index
  end

  def auth
    resp = DoscaAPI.auth(@params[:username], @params[:password], @params[:email])
    if has_error(resp)
      @error_message = resp[:message]
    else
      redirect_to Settings._settings[:server][:root_uri] + "/edit"
    end
  end

  private

  def init_session
  end
end
