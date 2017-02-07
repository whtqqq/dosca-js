class EditController < ApplicationController
  def past
    username = @session["username"]
    contents = @session[username]
  end

  def news
    username = @session["username"]
    contents = @session[username]
  end
end
