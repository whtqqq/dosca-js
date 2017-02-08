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

def download(filename)
  open(filename) do |fp|
    basename = File.basename(filename)
    cgi = CGI.new
    header = { 
      "type" => "application/pdf",
      "length" => fp.stat.size,
      "Content-Disposition"=>"download;filename=\"#{basename}\""}
    
    cgi.out(header) do
      fp.read
    end
  end
rescue => e
  cgi = CGI.new
  puts "Content-Type: application/json\n"
  resp_error
end

download("./past_incident.pdf")
