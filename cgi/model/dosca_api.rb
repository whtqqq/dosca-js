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
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end

  def DoscaAPI.categories(client_code, mail, contents_code)
    request_common Settings._settings[:api][:categories_url], client_code, mail, contents_code
  end

  def DoscaAPI.ports(client_code, mail, contents_code)
    request_common Settings._settings[:api][:ports_url], client_code, mail, contents_code
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

    resp = http.request(req)
    return Application.symbolize_keys(JSON.parse(resp.body)) if resp.header.index("application/json")

    filename = Settings._settings[:server][:temp_pdf_directory] + "/"
             + resp.header["Content-Disposition"].match(/filename=\"(.+)\"/)[1]
    File.open(filename,"w"){ |f|
      resp.read_body{ |seg|
        f << seg
        sleep 0.005 
      }
    }
    filename
  end

  def DoscaAPI.new(client_code, mail, contents_code, pdf_file, submit_data)
    update_common(Settings._settings[:api][:new_url],
               client_code, mail, contents_code, nil, pdf_file, submit_data)
  end

  def DoscaAPI.update(client_code, mail, contents_code, contents_no, submit_data)
    update_common(Settings._settings[:api][:update_url],
               client_code, mail, contents_code, contents_no, pdf_file, submit_data)
  end

  def DoscaAPI.remove(client_code, mail, contents_code, contents_no)
    request_common(Settings._settings[:api][:remove_url],
                client_code, mail, contents_code, contents_no)
  end

  private

  def DoscaAPI.request_common(url, client_code, mail, contents_code, contents_no=nil)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    req.body = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }.to_json

    req.body[:contents_no] = contents_no if contents_no

    resp = http.request(req)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end

  def DoscaAPI.update_common(client_code, mail, contents_code, contents_no, pdf_file, submit_data)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)

    my_boundary = "AaB03x0lsmtxm2"
    header = {"type"=> "multipart/form-data, boundary=#{my_boundary}"}
    req = Net::HTTP::Post.new(uri.request_uri, header)

    json  = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }.to_json
    json["contents_no"] = contents_no if contents_no

    #add submit data
    json["subject"] = submit_data[:subject] || ""
    json["category"] = submit_data[:category] || ""
    json["summary"] = submit_data[:summary] || ""
    json["web_page"] = submit_data[:web_page] || ""
    json["termination_date"] = submit_data[:termination_date] || ""
    json["date_time"] = submit_data[:date_time] || ""
    json["cargo"] = submit_data[:cargo] || ""
    json["vessel_name"] = submit_data[:vessel_name] || ""

    if !submit_data[:location].blank?
      localtion = submit_data[:latitude].split(",")
      json["longitude"] = location[0]
      json["latitude"] = location[1]
    end


    post_body = []

    # add json
    post_body << "--#{my_boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"contents_key[]\"\r\n\r\n"
    post_body << "Content-Type: application/json\r\n\r\n"
    post_body << json
    post_body << "\r\n\r\n--#{my_boundary}--\r\n"

    # add file data
    post_body << "--#{my_boundary}\r\n"
    post_body << "Content-Disposition: form-data; name=\"contents_key[][pdf]\"; filename=\"#{File.basename(pdf_file)}\"\r\n"
    post_body << "Content-Type: application/pdf\r\n\r\n"
    post_body << File.read(pdf_file)
     
    req.body = post_body.join

    resp = http.request(req)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end
end
