require 'net/http'
require 'uri'
require 'json'

class DoscaAPI
  def DoscaAPI.auth(username, password, mail)
    uri = URI.parse(Settings._settings[:api][:login_url])
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    req.body = {
         "user_name" => username,
         "password" => password,
         "mail" => mail 
    }.to_json

    resp = http.request(req)
    LogWriter.info(mail, File.basename(uri.to_s) +  " request:" + req.body.to_s)
    LogWriter.info(mail, File.basename(uri.to_s) + " response:" + resp.body.to_s)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end

  def DoscaAPI.categories(client_code, mail, contents_code)
    request_common Settings._settings[:api][:categories_url], client_code, mail, contents_code, nil, true
  end

  def DoscaAPI.ports(client_code, mail, contents_code)
    request_common Settings._settings[:api][:ports_url], client_code, mail, contents_code, nil, true
  end

  def DoscaAPI.history_list(client_code, mail, contents_code)
    request_common Settings._settings[:api][:history_list_url], client_code, mail, contents_code
  end

  def DoscaAPI.history_detail(client_code, mail, contents_code, contents_no)
    request_common(Settings._settings[:api][:history_detail_url], client_code, mail, contents_code, contents_no)
  end

  def DoscaAPI.pdf_download(client_code, mail, contents_code, contents_no)
    uri = URI.parse(Settings._settings[:api][:pdf_download_url])
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    req.body = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code,
         "contents_no" => contents_no
    }.to_json

    file_name = nil
    original_name = nil
    http.request(req) do |resp|
      original_name =  resp.header["Content-Disposition"].match(/filename=\"(.+)\"/)[1]
      file_name = Settings._settings[:server][:pdf_directory]+ "/" + original_name
      File.open(file_name, "w") do |f|
        resp.read_body{ |seg|
          f << seg
        }
      end
    end

    LogWriter.info(mail, File.basename(uri.to_s) +  " request:" + req.body.to_s)
    LogWriter.info(mail, File.basename(uri.to_s) + " response:" + original_name)
    original_name
  end

  def DoscaAPI.new(client_code, mail, contents_code, pdf_file, submit_data)
    update_common(Settings._settings[:api][:new_url],
               client_code, mail, contents_code, nil, pdf_file, submit_data)
  end

  def DoscaAPI.update(client_code, mail, contents_code, contents_no, pdf_file, submit_data)
    update_common(Settings._settings[:api][:update_url],
               client_code, mail, contents_code, contents_no, pdf_file, submit_data)
  end

  def DoscaAPI.remove(client_code, mail, contents_code, contents_no)
    request_common(Settings._settings[:api][:remove_url],
                client_code, mail, contents_code, contents_no)
  end

  private

  def DoscaAPI.request_common(url, client_code, mail, contents_code, contents_no=nil, no_log=false)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    body = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }
    body["contents_no"] = contents_no unless contents_no.nil? || contents_no.empty?
    req.body = body.to_json

    resp = http.request(req)

    LogWriter.info(mail, File.basename(uri.to_s) +  " request:" + req.body.to_s)
    unless no_log
      LogWriter.info(mail, File.basename(uri.to_s) + " response:" + resp.body.to_s)
    else
      LogWriter.info(mail, File.basename(uri.to_s) + " response: OK")
    end
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end

  def DoscaAPI.update_common(url, client_code, mail, contents_code, contents_no, pdf_file, submit_data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    my_boundary = "AaB03x0lsmtxm2"
    header = {"type"=> "multipart/form-data, boundary=#{my_boundary}"}
    req = Net::HTTP::Post.new(uri.request_uri, header)

    data  = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }
    data["contents_no"] = contents_no unless contents_no.nil? || contents_no.empty?

    #add submit data
    data["subject"] = submit_data[:subject] || ""
    data["category"] = submit_data[:category] || ""
    data["summary"] = submit_data[:summary] || ""
    data["web_page"] = submit_data[:web_page] || ""
    data["termination_date"] = submit_data[:termination_date] || ""
    data["date_time"] = submit_data[:date_time] || ""
    data["cargo"] = submit_data[:cargo] || ""
    data["vessel_name"] = submit_data[:vessel_name] || ""

    unless submit_data[:location].nil? || submit_data[:location].empty?
      localtion = submit_data[:latitude].split(",")
      data["longitude"] = location[0]
      data["latitude"] = location[1]
    end


    post_body = []

    # add json
    post_body << "--#{my_boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"contents_key[]\"\r\n\r\n"
    post_body << "Content-Type: application/json\r\n\r\n"
    post_body << data.to_json
    post_body << "\r\n\r\n--#{my_boundary}--\r\n"

    # add file data
    basename = File.basename(pdf_file)
    post_body << "--#{my_boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"contents_key[][pdf]\"; filename=\"#{basename}\"\r\n"
    post_body << "Content-Type: application/pdf\r\n\r\n"
    post_body << File.read(pdf_file)
     
    req.body = post_body.join

    resp = http.request(req)
    LogWriter.info(mail, File.basename(uri.to_s) +  " request:" + data.to_s)
    LogWriter.info(mail, File.basename(uri.to_s) + " response:" + resp.body.to_s)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end
end
