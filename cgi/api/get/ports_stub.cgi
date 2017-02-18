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
    "ports": [
        {
            "Tokyo": [
                "35.8N", 
                "140E"
            ]
        }, 
        {
            "Kobe": [
                "34N",
                "136E"
            ]
        }
    ]
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
