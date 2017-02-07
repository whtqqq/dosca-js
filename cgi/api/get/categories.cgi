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
    "categories": [
        "Sinking", 
        "Aground", 
        "Collision", 
        "Oil Leak", 
        "Water Seepage", 
        "Engine Fault"
    ]
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
