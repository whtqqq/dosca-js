#!/usr/bin/ruby

require 'cgi'

def resp_error
puts <<END
{
  "result": "ERROR",
  "message": "update failed."
}
END
end

def resp_success
puts <<END
{
  "result": "SUCCESS",
  "message": ""
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

resp_success
