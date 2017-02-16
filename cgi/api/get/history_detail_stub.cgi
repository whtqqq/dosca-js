#!/usr/bin/ruby

require 'cgi'

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
    "latitude": "145-56.3 E",
    "longitude": "45-35.8 N"
}
END
end

def resp_past
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "category": "Aground",
    "date_time": "2017-2-17 23 50",
    "vessel_name": "kawasaki maru",
    "termination_date": "2016-12-31",
    "latitude": "145-56.3 E",
    "longitude": "45-35.8 N"
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
