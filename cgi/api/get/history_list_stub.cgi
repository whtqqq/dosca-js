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
    "histories": [
        {
            "no": "000",
            "title": "2016/11/02_03:42:13 Machinery Damage",
            "contents_no": "0001"
        },
        {
            "no": "001",
            "title": "2016/10/26_02:09:08 Collision",
            "contents_no": "0002"
        }
    ]
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
