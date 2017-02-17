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
            "title": "2016/11/02_03:42:13 Machinery Damage mol new 001",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/10/26_02:09:08 Collision mol new 002",
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
            "title": "2016/11/02_03:42:13 Machinery Damage mol past 001",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/10/26_02:09:08 Collision mol past 002",
            "contents_no": "000002"
        }
    ]
}
END
end

def resp_success_nyk_past
puts <<END
{
    "histories": [
        {
            "no": "000",
            "title": "2016/11/02_03:42:13 Machinery Damage nyk 001",
            "contents_no": "000001"
        },
        {
            "no": "001",
            "title": "2016/10/26_02:09:08 Collision nyk 002",
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
