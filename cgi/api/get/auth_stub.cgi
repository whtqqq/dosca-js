#!/usr/bin/ruby

require 'cgi'

def resp_error
puts <<END
{
  "result": "ERROR",
  "message": "login failed."
}
END
end

def resp_success
puts <<END
{
    "client_code": "MOL",
    "mail": "cap001@gmail.com",
    "contents": [
        {
            "no": "1",
            "code": "INCIDENT_NEWS",
            "name": "Incident News"
        },
        {
            "no": "0",
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

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
