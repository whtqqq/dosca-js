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
    uri = URI.parse(Settings._settings[:api][:categories_url])
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    req.body = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }.to_json
    resp = http.request(req)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end

  def DoscaAPI.ports(client_code, mail, contents_code)
    uri = URI.parse(Settings._settings[:api][:ports_url])
    http = Net::HTTP.new(uri.host, uri.port)
     
    req = Net::HTTP::Post.new(uri.request_uri)
     
    req["Content-Type"] = "application/json"
    req.body = {
         "client_code" => client_code,
         "mail" => mail,
         "contents_code" => contents_code
    }.to_json
    resp = http.request(req)
    Application.symbolize_keys(JSON.parse(resp.body)) 
  end
end
