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
  "message": "no data found."
}
END
end

def resp_news
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "subject": "Vessel A sank in the off Kashima",
    "category": "Oil Leak",
    "summary": "The engine room oinity of the sailing ship.Ship Charactoristics",
    "web_page": "http://dosca.com",
    "termination_date": "2016-12-31",
    "latitude": "145.3E",
    "longitude": "35.8N"
}
END
end

def resp_past
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "category": "Aground",
    "cargo": "Nagoya Center",
    "date_time": "2017-2-17 23 50",
    "vessel_name": "kawasaki maru",
    "termination_date": "2016-12-31",
    "latitude": "56.3E",
    "longitude": "43.8N"
}
END
end

cgi = CGI.new



puts "Content-Type: application/json\n"

puts ""

json = cgi.params

json = JSON.parse(json.to_s)
if json["contents_code"].index("NEWS").nil?
  resp_past
else
  resp_news
end
