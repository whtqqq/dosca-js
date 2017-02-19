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

def resp_success_mol_new_1
puts <<END
{
    "contents no": "0000001",
    "issue_date": "2016/01/14 06:33:59",
    "subject": "Vessel A sank in the off Kashima",
    "category": "For MOL New",
    "summary": "contents_no : 000001 The engine room oinity of the sailing ship.Ship Charactoristics",
    "web_page": "http://dosca.com/MOL_NEW-1",
    "termination_date": "2015-12-31",
    "latitude": "35-48.8 N",
    "longitude": "145-18.3 E"
}
END
end

def resp_success_mol_new_2
puts <<END
{
    "issue_date": "2016/11/11 06:00:59",
    "subject": "For test contents_no :000002",
    "category": "Oil Leak",
    "summary": "The engine room oinity of the sailing ship.Ship Charactoristics",
    "ports": "FLORO (FLORA)",
    "latitude": "61-36.29 N",
    "longitude": "5-1.7 E"
}
END
end

def resp_success_mol_past_1
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "category": "Aground",
    "cargo": "Nagoya Center",
    "date_time": "2017-03-30 23:50",
    "vessel_name": "kawasaki maru MOL1",
    "termination_date": "2018-12-31",
    "ports": "TOKYO",
    "latitude": "56-18.3 N",
    "longitude": "43-48.8 E"
}
END
end

def resp_success_mol_past_2
puts <<END
{
    "issue_date": "2016/12/14 06:33:59",
    "category": "Collision",
    "cargo": "Nagoya",
    "date_time": "2017-02-13 23:47",
    "vessel_name": "kawasaki maru MOL2",
    "latitude": "56-18.3 N",
    "longitude": "43-48.8 E"
}
END
end

def resp_success_nyk_past_1
puts <<END
{
    "issue_date": "2016/11/14 06:33:59",
    "category": "Aground",
    "cargo": "Nagoya Center",
    "date_time": "2017-02-17 23:50",
    "vessel_name": "kawasaki maru nyk1",
    "termination_date": "2016-12-31",
    "ports": "TOKYO",
    "latitude": "56-18.3 N",
    "longitude": "43-48.8 E"
}
END
end

def resp_success_nyk_past_2
puts <<END
{
    "issue_date": "2016/11/28 00:00:00",
    "category": "Collision",
    "cargo": "Nagoya",
    "date_time": "2017-02-11 23:49",
    "vessel_name": "kawasaki maru nyk2",
    "latitude": "0-18.3 N",
    "longitude": "140-48.8 E"
}
END
end

cgi = CGI.new

puts "Content-Type: application/json\n"

puts ""

json = cgi.params

json = JSON.parse(json.to_s)

unless json["client_code"].index("NYK").nil?
  if json["contents_no"].eql?("000001")
    $stderr.puts "-----NYK-1--------"
    resp_success_nyk_past_1
  else
    $stderr.puts "-----NYK-1--------"
    resp_success_nyk_past_2
  end
end 

unless json["client_code"].index("MOL").nil?
  unless json["contents_code"].index("NEW").nil?
    if json["contents_no"].eql?("000001")
      $stderr.puts "-----MOL_NEW-1--------"
      resp_success_mol_new_1
    else
      $stderr.puts "-----MOL_NEW-2--------"
      resp_success_mol_new_2
    end
  else
    if json["contents_no"].eql?("000001")
      $stderr.puts "-----MOL_PAST-1--------"
      resp_success_mol_past_1
    else
      $stderr.puts "-----MOL_PAST-2--------"
      resp_success_mol_past_2
    end
  end
end
