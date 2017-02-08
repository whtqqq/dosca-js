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

def resp_success
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "subject": "Vessel A sank in the off Kashima",
    "category": "MOL_INCIDENT_NEWS",
    "summary": "The engine room of  M/V MURAT HACIBEKIROGLU II flooded, sank off the coast of Turkey. Entire crew of 10 people in the lifeboat, was rescued in the vicinity of the sailing ship.\n\n<Ship Charactoristics>",
    "web_page": "http://dosca.com",
    "termination_date": "2016/12/31",
    "latitude": "145-56.3 E",
    "longitude": "45-35.8 N"
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
