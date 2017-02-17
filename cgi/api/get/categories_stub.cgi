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
    "categories": [
        "Sinking", 
        "Aground", 
        "Collision", 
        "Oil Leak", 
        "Water Seepage", 
        "Engine Fault",
        "For MOL New"
    ]
}
END
end

def resp_success_mol_past
puts <<END
{
    "categories": [
        "Sinking", 
        "Aground", 
        "Collision", 
        "Oil Leak", 
        "Water Seepage", 
        "Engine Fault",
        "For MOL Past"
    ]
}
END
end

def resp_success_nyk
puts <<END
{
    "categories": [
        "Sinking", 
        "Aground", 
        "Collision", 
        "Oil Leak", 
        "Water Seepage", 
        "Engine Fault",
        "For NYK"
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
    $stderr.puts "-----NYK_NEW---------"
    resp_success_mol_new
  else
    $stderr.puts "-----NYK_PAST---------"
    resp_success_mol_past
  end
end