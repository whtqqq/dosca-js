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

def resp_success_mol_new
puts <<END
{
    "histories": [
        {
            "no": "000",
            "title": "2016/01/14 06:33:59 Vessel A sank in the off Kashima",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/11/11 06:00:59 For test contents_no :000002",
            "contents_no": "000002"
        }
    ]
}
END
end

def resp_success_mol_past
puts <<END
{
    "histories": [
        {
            "no": "000",
            "title": "2016/11/14 06:33:59 kawasaki maru MOL1",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/12/14 06:33:59 kawasaki maru MOL2",
            "contents_no": "000002"
        }
    ]
}
END
end

def resp_success_nyk
puts <<END
{
    "histories": [
        {
            "no": "000",
            "title": "2016/11/14 06:33:59 kawasaki maru nyk1",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/11/28 00:00:00 kawasaki maru nyk2",
            "contents_no": "000002"
        }
    ]
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

json = cgi.params

$stderr.puts json

json = JSON.parse(json.to_s)

unless json["client_code"].index("NYK").nil?
$stderr.puts "-----NYK---------"
  resp_success_nyk
end 

unless json["client_code"].index("MOL").nil?
  unless json["contents_code"].index("NEW").nil?
    $stderr.puts "-----MOL_NEW---------"
    resp_success_mol_new
  else
    $stderr.puts "-----MOL_PAST---------"
    resp_success_mol_past
  end
end
