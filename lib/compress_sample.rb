#!/usr/local/bin/ruby


require 'rubygems'
require 'zipruby'     # <- MOST IMPORTANT!!
require 'digest/md5'
require 'fileutils'

require 'logwrite2'


$log = nil

def make_passwd_zip( client_code, contents_code, contents_no, update_date, src_pdf_fname, dst_zip_fname )

  # Make Password sting
  # "MOL|MOL_INCIDENT_REPORT|000000|2016-03-09T12:34:50"
  t = update_date.strftime( "%Y-%m-%dT%H:%M:%S" )
  seed = sprintf( "%s|%s|%06d|%s", client_code, contents_code, contents_no, t )
  pass = Digest::MD5.hexdigest( seed )
  $log.info( "  Make Password zip file [#{src_pdf_fname}]" )
  $log.info( "    - Src File [#{src_pdf_fname}]" )
  $log.info( "    - Seed [#{seed}]" )
  $log.info( "    - Pass [#{pass}]" )
  $log.info( "    - Zip File [#{dst_zip_fname}]" )

  FileUtils.mkdir_p( File.dirname( dst_zip_fname ) )

  dst_pdf_fname = "#{File.dirname( dst_zip_fname )}/#{File.basename( dst_zip_fname, ".zip" )}.pdf"
  FileUtils.cp( src_pdf_fname, dst_pdf_fname )

  # Make Zip Archive
  tmp_fname = "#{dst_zip_fname}.#{$$}"
  Zip::Archive.open( tmp_fname, Zip::CREATE) do |arc|
    arc.add_file( dst_pdf_fname )
  end

  # Locked Password
  Zip::Archive.encrypt( tmp_fname, pass )

  if File.exist?( dst_zip_fname )
    FileUtils.rm( dst_zip_fname )
  end
  FileUtils.mv( tmp_fname, dst_zip_fname )

#rescue
#  FileUtils.rm( dst_zip_fname )
#  dst_zip_fname = nil
#  $log.error( $! )
#  $@.each do |msg|
#    $log.error( "\t#{msg}" )
#  end
ensure
  if File.exist?( tmp_fname )
    FileUtils.rm( tmp_fname )
  end
  if File.exist?( dst_pdf_fname )
    FileUtils.rm( dst_pdf_fname )
  end

  return dst_zip_fname
end


begin
  tm_str = Time.now.utc.strftime( "%Y%m%d" )
  log_dir   = "./log"
  prog_name = File.basename( $PROGRAM_NAME )
  log_fname = "#{log_dir}/#{prog_name}.#{tm_str}.log"
  if !File.exist?( log_dir )
    FileUtils.mkdir( log_dir )
  end
  $log = LogWrite2.new( log_fname, 10, 10000000 )

  if ARGV.size != 5
    puts "#{prog_name} {Client Code} {Contents Code} {Contents No} {Src PDF Path} {Output Zip File}"
    puts ""
    puts "  ex) #{prog_name} MOL MOL_INCIDENT_NEWS 000000 ./src.pdf ./out.zip"
    puts ""
    puts "  Output Zip file need 'PKZIP' format!!"
    exit
  end

  client_code   = ARGV[0]
  contents_code = ARGV[1]
  contents_no   = ARGV[2]
  update_date   = Time.now.utc
  src_pdf_fname = ARGV[3]
  dst_zip_fname = ARGV[4]
  make_passwd_zip( client_code, contents_code, contents_no, update_date, src_pdf_fname, dst_zip_fname )
rescue
  $log.error( $! )
  $@.each do |msg|
    $log.error( "\t#{msg}" )
  end
ensure
  $log.info( "Prcess finish." )
end


