#!/usr/bin/ruby

require 'rubygems'
require 'bundler'

Bundler.require

require 'cgi'
require 'json'

def resp_error
puts <<END
{
  "result": "ERROR",
  "message": "login failed."
}
END
end

def resp_success_mol
puts <<END
{
    "client_code": "MOL",
    "mail": "NYK001@gmail.com",
    "contents": [
        {
            "no": "0",
            "code": "INCIDENT_NEWS",
            "name": "Incident News"
        },
        {
            "no": "1",
            "code": "PAST_INCIDENT",
            "name": "Past Incident"
        }
    ],
    "disp": {
        "INCIDENT_NEWS": {
            "category": "CATEGORY",
            "subject": "Subject",
            "summary": "Summary",
            "picture": "Picture",
            "web_page": "Web page"
        },
        "PAST_INCIDENT": {
            "category": "CATEGORY",
            "date_time": "DATE and TIME of occurrence of the incident(UTC)",
            "vessel_name": "VESSEL NAME",
            "cargo": "CARGO"
        }
    }
}
END
end

def resp_success_nyk
puts <<END
{
    "client_code": "NYK",
    "mail": "NYK001@gmail.com",
    "contents": [
        {
            "no": "0",
            "code": "PAST_INCIDENT",
            "name": "Past Incident"
        }
    ],
    "disp": {
        "PAST_INCIDENT": {
            "category": "CATEGORY",
            "date_time": "DATE and TIME of occurrence of the incident(UTC)",
            "vessel_name": "VESSEL NAME",
            "cargo": "CARGO"
        }
    }
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

json = cgi.params

$stderr.puts json

json = JSON.parse(json.to_s)

unless json["user_name"].index("MOL").nil?
$stderr.puts "-----MOL---------"
  resp_success_mol
end 
unless json["user_name"].index("NYK").nil?

$stderr.puts "-----NYK---------"
  resp_success_nyk
end

unless json["user_name"].index("ERR").nil?

$stderr.puts "-----error---------"
  resp_error
end
