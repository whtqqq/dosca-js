class EditController < ApplicationController
  def past
    user_info = user_info_from_session

    @past_contents = extract_contents(user_info, "PAST_INCIDENT")

    @items = user_info[:disp][@past_contents[:code].to_sym]
    @categories = user_info[:categories][@past_contents[:code].to_sym]
    @ports = user_info[:ports][@past_contents[:code].to_sym]

    if user_info[:contents].size > 1
      @news_contents = extract_contents(user_info, "INCIDENT_NEWS")
    end

    @histories = fetch_histories(user_info,  @past_contents[:code])

    contents_no = @params[:contents_no]
    contents_data = {} 
    contents_data = fetch_history_detail(
                      user_info[:client_code], 
                      user_info[:mail], 
                      @past_contents[:code], 
                      contents_no) if contents_no
    status = ""
    status = "EDIT" if contents_no  
    status = "NEW" if  !contents_no && @params[:category] 
    pdf_file = @params[:file][0].original_filename

    if status == "NEW"
      edit_proc(user_info, @past_contents, contents_data, contents_no, pdf_file)
    end

    if status == "EDIT"
      edit_proc(user_info, @past_contents, contents_data, contents_no, pdf_file)
    end
  end

  def news
    user_info = user_info_from_session

    @news_contents = extract_contents(user_info, "INCIDENT_NEWS")
    if user_info[:contents].size > 1
      @past_contents = extract_contents(user_info, "PAST_INCIDENT")
    end

    @items = user_info[:disp][@news_contents[:code].to_sym]
    @categories = user_info[:categories][@news_contents[:code].to_sym]
    @ports = user_info[:ports][@news_contents[:code].to_sym]

    @histories = fetch_histories(user_info,  @news_contents[:code])
    contents_no = @params[:contents_no]
    contents_data = {} 
    contents_data = fetch_history_detail(
                      user_info[:client_code], 
                      user_info[:mail], 
                      @news_contents[:code], 
                      contents_no) if contents_no
    status = ""
    status = "EDIT" if contents_no  
    status = "NEW" if  !contents_no && @params[:category] 

    if status == "NEW"
      pdf_file = create_pdf(user_info[:client_code], @news_contents[:code], contents_no, @params)
      edit_proc(user_info, @news_contents, contents_data, contents_no)
    end

    if status == "EDIT"
      pdf_file = create_pdf(user_info[:client_code], @news_contents[:code], contents_no, @params)
      edit_proc(user_info, @news_contents, contents_data, contents_no)
    end
  end

  private
  def new_proc(user_info, contents, contents_data, contents_no, pdf_file)
    resp = DoscaAPI.new(user_info[:client_code],
                      user_info[:mail], contents[:code],  @params) 
    if !has_error?(resp)
      @error_message = "server error"
      return
    end

    resp = DoscaAPI.pdf_upload(user_info[:client_code],
                      user_info[:mail], contents[:code], contents_no, pdf_file) 
    if !has_error?(resp)
      @error_message = "server error"
    end
  end

  def edit_proc(user_info, contents, contents_data, contents_no, pdf_file)
    if !dirty?(contents_data, @params)
      @error_message = "no change"
      return
    end
    resp = DoscaAPI.update(user_info[:client_code],
                        user_info[:mail], contents[:code], contents_no, @params) 
    if !has_error?(resp)
      @error_message = "server error"
      return
    end
      
    resp = DoscaAPI.pdf_upload(user_info[:client_code],
                      user_info[:mail], contents[:code], contents_no, pdf_file) 
    if !has_error?(resp)
      @error_message = "server error"
    end
  end

  def extract_contents(user_info, keyword)
    user_info[:contents].select{|h| h[:code].index(keyword)}.first
  end

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
    
    #sort by no
    his.sort_by{|item| item[:no]} if his.size > 1
  end

  def fetch_history_detail(user_info, contents_code, conents_no)
    resp = DoscaAPI.history_list(user_info[:client_code], user_info[:mail], contents_code, contents_no) 
    if has_error?(resp)
      {}
    else
      resp
    end
  end

  def dirty?(before, after)
    return true if before.empty?
    before.each {|key, value|
      return true if value != after[key]
    }
    return false
  end
 
  def create_pdf(client_code, contents_code, contents_no, data)
    path = URI.parse(Settings._settings[:server][:temp_pdf_directory])
    pdf_name = path + "/" + [client_code, contents_code, contents_no].join("_") + ".pdf"
    map_picture = data[:file][0]
    news_pictures = data[:file] - data[:file][0]

    pdf = PDFCreator.new(pdf_name, 
           "", 
          data[:latitue] + " " + data[:longitude], data[:category],
          data[:subject],
          data[:summary],
          map_picture, news_pictures)
    pdf.create()

    pdf_name
  end
end
