#!/usr/bin/ruby


require 'fileutils'
require 'logwrite2'


tm_str = Time.now.utc.strftime( "%Y%m%d" )
log_dir   = "./log"
prog_name = File.basename( $PROGRAM_NAME )
log_fname = "#{log_dir}/#{prog_name}.#{tm_str}.log"
if !File.exist?( log_dir )
  FileUtils.mkdir( log_dir )
end
$log = LogWrite2.new( log_fname, 10, 10000000 )


begin


  $log.info( "This is normal infomation" )

  $log.warn( "This is warning information" )

rescue
  $log.error( "This is error information." )
  $log.error( $! )
  $@.each do |msg|
    $log.error( "\t#{msg}" )
  end
ensure
  $log.info( "Prcess finish." )
end

