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
                "45-35.8 N", 
                "145-56.3 E"
            ]
        }, 
        {
            "Kobe": [
                "45-135.8 N", 
                "145-856.3 E"
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
