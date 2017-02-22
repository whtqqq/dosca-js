require 'base64'

class EditController < ApplicationController
  STATUS_NEW = 1
  STATUS_SHOW = 2
  STATUS_EDIT = 4
  
  def past
    LogWriter.info("System", "Edit#past Start.")

    user_info = {}
    begin
      user_info = user_info_from_session
    rescue => e
      redirect_to @root_uri + "/login"
      return 
    end

    @mail = user_info[:mail]
    @client_code = user_info[:client_code]
    @past_contents = extract_contents(user_info, "PAST_INCIDENT")
    @items = user_info[:disp][@past_contents[:code].to_sym]
    @categories = user_info[:categories][@past_contents[:code].to_sym]
    @ports = user_info[:ports][@past_contents[:code].to_sym]

    if user_info[:contents].size > 1
      @news_contents = extract_contents(user_info, "INCIDENT_NEWS")
    end

    @histories = fetch_histories( @past_contents[:code])
    contents_no = @params[:contents_no]
    @values ||= {} 
    unless empty?(contents_no) 
      dosca_values = fetch_history_detail(@past_contents[:code], contents_no)  
      copy_values(@values, dosca_values)
    end


    @values[:contents_code] =  @past_contents[:code]
    @values[:contents_no] = contents_no
    gui_status = @params[:status]
    status = ""

    if empty?(gui_status)
      status = STATUS_SHOW unless empty?(contents_no)
    else
      status = STATUS_EDIT unless empty?(contents_no)  
      status = STATUS_NEW if  empty?(contents_no) && !empty?(@params[:category]) 
    end
    @values[:status] = status
    
    if status == STATUS_NEW
      new_proc(@past_contents, @values, contents_no, find_last_file)
      unless empty?(@error_message)
        copy_values(@values, @params)
      else
        clear_values
      end
    end

    if status == STATUS_EDIT

      if !dirty?(@values, @params)
        @error_message = "No change occurred."
        copy_values(@values,  @params)
        LogWriter.info("System", "Edit#past End.")
        return
      end

      file = nil
      unless empty?(@session["files"])
        file = find_last_file
      end
      edit_proc(@past_contents, @values, contents_no, file, false)
      unless empty?(@error_message)
        copy_values(@values, @params)
      else
        clear_values
      end
    end
    
    if status == STATUS_SHOW
      pdf_file =  DoscaAPI.pdf_download(@client_code, 
                              @mail, @past_contents[:code], contents_no) 

      @values[:pdf_file] = Settings._settings[:server][:contents_pdf_uri] + "/" + pdf_file
      @session["original_pdf_file"] = @values[:pdf_file] 
      if empty?(@values[:termination_date])
        @values[:period]  = nil 
      else 
        @values[:period]  = "period"
      end
    end

    LogWriter.info("System", "Edit#past End.")
  end

  def news
    LogWriter.info("System", "Edit#news Start.")

    user_info = {}
    begin
      user_info = user_info_from_session
    rescue => e
      redirect_to @root_uri + "/login"
      return 
    end

    @mail = user_info[:mail]
    @client_code = user_info[:client_code]

    @news_contents = extract_contents(user_info, "INCIDENT_NEWS")
    if user_info[:contents].size > 1
      @past_contents = extract_contents(user_info, "PAST_INCIDENT")
    end

    @items = user_info[:disp][@news_contents[:code].to_sym]
    @categories = user_info[:categories][@news_contents[:code].to_sym]
    @ports = user_info[:ports][@news_contents[:code].to_sym]

    @histories = fetch_histories(@news_contents[:code])
    contents_no = @params[:contents_no]
    @values ||= {} 
    unless empty?(contents_no) 
      dosca_values = fetch_history_detail(@news_contents[:code], contents_no)  
      copy_values(@values, dosca_values)
    end

    @values[:contents_code] =  @news_contents[:code]
    @values[:contents_no] = contents_no
    gui_status = @params[:status]
    status = ""

    if empty?(gui_status)
      status = STATUS_SHOW unless empty?(contents_no)
    else
      status = STATUS_EDIT unless empty?(contents_no)  
      status = STATUS_NEW if  empty?(contents_no) && !empty?(@params[:category]) 
    end
    @values[:status] = status

    if status == STATUS_NEW
      new_proc(@news_contents, @values, contents_no, nil)
      unless empty?(@error_message)
        copy_values(@values,  @params)
      else
        clear_values
      end
    end

    if status == STATUS_EDIT
      if !dirty?(@values, @params)
        @error_message = "No change occurred."
        copy_values(@values,  @params)
        LogWriter.info("System", "Edit#news End.")
        return
      end

      edit_proc(@news_contents, @values, contents_no, nil, true)
      unless empty?(@error_message)
        copy_values(@values,  @params)
      else
        clear_values
      end
    end

    if status == STATUS_SHOW
      pdf_file =  DoscaAPI.pdf_download(@client_code, 
                              @mail, @news_contents[:code], contents_no) 

      @values[:pdf_file] = Settings._settings[:server][:contents_pdf_uri] + "/" + pdf_file
      if @values[:termination_date].nil? ||  @values[:termination_date].empty?
        @values[:period]  = nil 
      else 
        @values[:period]  = "period"
      end
    end

    if status != STATUS_EDIT && status != STATUS_NEW
      delete_cached_files
    end

    LogWriter.info("System", "Edit#news End.")
  end

  def delete 
    LogWriter.info("System", "Edit#delete Start.")

    @no_render = true
    user_info = user_info_from_session
    @mail = user_info[:mail]
    @client_code = user_info[:client_code]

    resp = DoscaAPI.remove(@client_code, @mail, 
              @params[:contents_code], @params[:contents_no])
    @cgi.out("type" => "application/json") {
      resp.to_json
    }

    LogWriter.info("System", "Edit#delete End.")
  rescue => e
    api_response("ERROR", e.to_s)
    LogWriter.error(@mail, e.to_s)
  end

  def preview
    LogWriter.info("System", "Edit#preview Start.")
    @no_render = true
    user_info = user_info_from_session
    @mail = user_info[:mail]
    @client_code = user_info[:client_code]

    news_contents = extract_contents(user_info, "INCIDENT_NEWS")
    pdf_file = create_pdf(@params[:contents_code], @params[:contents_no], 
                        news_contents[:name], utc_time, @params)

    open(pdf_file) do |fp|
      basename = File.basename(pdf_file)
      header = {
        "type" => "application/pdf",
        "length" => fp.stat.size,
        "Content-Disposition"=>"download;filename=\"#{basename}\""}
      @cgi.out(header) do
        fp.read
      end
    end

    File.delete pdf_file if File.exist?(pdf_file)
    LogWriter.info("System", "Edit#preview End.")
  end

  def upload
    LogWriter.info("System", "Edit#upload Start.")
    @no_render = true
    user_info = user_info_from_session
    @mail = user_info[:mail]

    pictures = []
    pictures = JSON.parse(@session["files"]) unless empty?(@session["files"])

    files = @cgi.params["files[]"]
    if !files.is_a?(Array)
      picturs.push(save_temp_file(files))
    else
      files.each do |file|
        pictures.push(save_temp_file(file))
      end
    end
    @session["files"] = pictures.to_json
     
    api_response("SUCCESS", "")
    LogWriter.info("System", "Edit#upload End.")
  rescue Exception => e
    LogWriter.error(@mail, e.to_s)
    api_response("ERROR", e.to_s)
  end

  private

  def new_proc(contents, values, contents_no, pdf_file)
    if !pdf_file
      pdf_file = create_pdf(contents[:code], 
        contents_no, contents[:name], utc_time, @params)
    end

    resp = DoscaAPI.new(@client_code,
                      @mail, contents[:code],  pdf_file, @params) 
    if has_error?(resp)
      @error_message = resp[:message]
    else
      delete_cached_files
    end

    File.delete pdf_file if File.exist?(pdf_file)
  end

  def edit_proc(contents, values, contents_no, pdf_file, pdf_create_flg)
    if pdf_create_flg
      pdf_file = create_pdf(contents[:code], 
        contents_no, contents[:name], utc_time, @params)
    end

    resp = DoscaAPI.update(@client_code,
                        @mail, contents[:code], contents_no, pdf_file, @params) 
    if has_error?(resp)
      @error_message = resp[:message]
    else
      delete_cached_files
    end

    File.delete pdf_file if !empty?(pdf_file) && File.exist?(pdf_file)
  end

  def extract_contents(user_info, keyword)
    user_info[:contents].select{|h| h[:code].index(keyword)}.first
  end

  def user_info_from_session
    username = @session["username"]
    user_info_json = @session[username]
    Application.symbolize_keys(JSON.parse(user_info_json))
  end

  def fetch_histories(contents_code)
    resp = DoscaAPI.history_list(@client_code, @mail, contents_code)
    his = []
    if !has_error?(resp)
      his = resp[:histories]
    end
    
    #sort by no
    his.sort_by{|item| item[:no]} if his.size > 1
  end

  def fetch_history_detail(contents_code, contents_no)
    resp = DoscaAPI.history_detail(@client_code, @mail, contents_code, contents_no) 
    if has_error?(resp)
      {}
    else
      resp
    end
  end

  def dirty?(before, after)
    return true unless empty?(@session["files"])
    return true if before.empty?
    keys = [:subject, :category, :summary, 
             :web_page, :termination_date, 
            :cargo, :vessel_name,  :date_time, :position]
    before[:position] = before[:latitude] + " " + before[:longitude] 

    keys.each do |key|
      return true if before[key].to_s.strip != after[key].to_s.strip
    end
    
    return false
  end
 
  def create_pdf(contents_code, contents_no, title, issue_date, data)
    path = Settings._settings[:server][:temp_directory]
    pdf_name = path + "/" + [@client_code, contents_code, contents_no].join("_") + ".pdf"
    if empty?(contents_no)
      pdf_name = path + "/" + [@client_code, contents_code, "new"].join("_") + ".pdf"
    end
    map_picture = save_base64_picture(@cgi.params["map_picture"].to_s, path)

    pdf = PDFCreator.new(pdf_name, 
          title,
          issue_date, 
          data[:position],  data[:category],
          data[:subject],
          data[:summary],
          map_picture, find_real_files)
    pdf.create()

    File.delete map_picture if File.exist?(map_picture)

    pdf_name
  end

  def save_base64_picture(data_url, path)
    svg  = Base64.decode64(data_url["data:image/svg+xml;base64,".length..-1])
    file_name = path + "/" + edit_mail + "_chart.svg"
    File.open(file_name, "wb") { |f| f.write(svg) }
    file_name
  end
  
  def save_temp_file(file) 
    file_name = [milliseconds_string, edit_mail,  file.original_filename].join("_")
    path = [Settings._settings[:server][:temp_directory], file_name].join("/")
    File.open(path, "w") { |f| f.write file.read }
    path
  end

  def utc_time
    Time.now.utc.to_s
  end

  def empty?(obj) 
    return true if obj.nil?
    return true if obj.empty?
    return false 
  end

  def api_response(result, message)
    json = {
       "result" => result,
       "message" => message
    }.to_json

    @cgi.out("type" => "application/json")  {
       json
    }
  end

  def delete_cached_files
    news_pictures = []
    news_pictures = JSON.parse(@session["files"]) unless empty?(@session["files"])
    news_pictures.each do |file|
      File.delete file if File.exist?(file)
    end
    @session["files"] = nil
  end

  def clear_values
    keys = [:contents_no, :subject, :category, :summary, 
             :web_page, :termination_date, 
            :cargo, :vessel_name,  :date_time,
            :position, :latitude, :longitude]

    keys.each do |key|
      @values[key] = ""
    end
    @values[:status] = "1"
    @values[:pdf_file] = nil
    @session["original_pdf_file"] = nil
  end

  def copy_values(to, from)
    keys = [:subject, :category, :summary, 
             :web_page, :termination_date, 
            :cargo, :vessel_name,  :date_time,
            :position, :latitude, :longitude]

    keys.each do |key|
      to[key] = from[key]
    end

    if empty?(to[:termination_date])
      to[:period]  = nil 
    else 
      to[:period]  = "period"
    end

    unless empty?(to[:position])
      position = to[:position].match(/(.*)(N|S|s|n)(.*)/)
      to[:longitude] = position[1] + position[2]
      to[:latitude] = position[3].strip
    end

    to[:pdf_file] = @session["original_pdf_file"]
  end

  def edit_mail()
    parts = @mail.split("@")
    [parts[0], parts[1].split(".").join("_")].join("_")
  end

  def find_last_file
    files = []
    files  = JSON.parse(@session["files"]) unless empty?(@session["files"])
    files.last
  end

  def find_real_files
    files = []
    files  = JSON.parse(@session["files"]) unless empty?(@session["files"])
    r_files = files.reverse 
    t_files = @params[:file_names].to_s.strip.split(";")
    real_files = []
    
    edited_mail = edit_mail
    t_files.each do |tfile|
      r_files.each do |rfile|
        base_name = File.basename(rfile)
        if base_name.index([edited_mail, tfile].join("_"))
          real_files.push(rfile)
          break
        end
      end 
    end
    real_files 
  end

  def milliseconds_string
    Time.now.instance_eval {'%s%03d' % [strftime('%Y%m%d%H%M%S'), (usec / 1000.0).round]}
  end
end
