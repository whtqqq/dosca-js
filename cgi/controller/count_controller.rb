class CountController < ApplicationController
  def index
    init_session
    @access = @session[Count::SESSION_KEY].to_i
    @access += 1
    @session[Count::SESSION_KEY] = @access.to_s
  end

  private

  def init_session
    @session[Count::SESSION_KEY] ||= "0"
  end
end
