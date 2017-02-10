class EditController < ApplicationController
  def past
    user_info = user_info_from_session

    @past_contents = user_info[:contents].select{|h| h[:code].index("PAST_INCIDENT")}.first

    @items = user_info[:disp][@past_contents[:code].to_sym]
    @categories = user_info[:categories][@past_contents[:code].to_sym]
    @ports = user_info[:ports][@past_contents[:code].to_sym]

    if user_info[:contents].size > 1
      @news_contents = user_info[:contents].select{|h|
        h[:code].index("INCIDENT_NEWS")
      }.first
    end

    @histories = fetch_histories(user_info,  @past_contents[:code])
  end

  def news
    user_info = user_info_from_session

    @news_contents = user_info[:contents].select{|h| h[:code].index("INCIDENT_NEWS")}.first

    @items = user_info[:disp][@news_contents[:code].to_sym]
    @categories = user_info[:categories][@news_contents[:code].to_sym]
    $stderr.puts user_info.inspect
    @ports = user_info[:ports][@news_contents[:code].to_sym]

    if user_info[:contents].size > 1
      @past_contents = user_info[:contents].select{|h|
        h[:code].index("PAST_INCIDENT")
      }.first
    end

    @histories = fetch_histories(user_info,  @news_contents[:code])
  end

  private

  def user_info_from_session
    username = @session["username"]
    user_info_json = @session[username]
    Application.symbolize_keys(JSON.parse(user_info_json))
  end

  def fetch_histories(user_info, contents_code)
    resp = DoscaAPI.history_list(user_info[:client_code], user_info[:mail], contents_code)
    his = []
    if !has_error?(resp)
      his = resp[:histories]
    end
    
    his.sort_by{|item| item[:no]} if his.size > 1
  end
end
