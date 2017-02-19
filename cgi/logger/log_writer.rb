require 'fileutils'

# Example
#####################################################################################
#    LogWriter.write(email, "message")  >>>> write ? time ：［pid］ <email: controller> message
#    LogWriter.info(email, "message")   >>>> write I time ：［pid］ <email: controller> message
#    LogWriter.warn(email, "message")   >>>> write W time ：［pid］ <email: controller> message 
#    LogWriter.error(email, "message")  >>>> write E time ：［pid］ <email: controller> message
#    LogWriter.exit              >>>> close log writer

class LogWriter
  class << self
    def write(mail, str)
      @log = find_log_file
      @controller = Application.get_controller_and_action_name[:controller]
      @log.puts "? #{nowtime()} [#{$$}] < #{mail} > #{str} "
      @log.flush
    end
  
    def info(mail, str)
      @log = find_log_file
      @controller = Application.get_controller_and_action_name[:controller]
      @log.puts "I #{nowtime()} [#{$$}] < #{mail} > #{str} "
      @log.flush
    end
  
    def warn(mail, str)
      @log = find_log_file
      @controller = Application.get_controller_and_action_name[:controller]
      @log.puts "W #{nowtime()} [#{$$}] < #{mail} > #{str} "
      @log.flush
    end
  
    def error(mail, str)
      @log = find_log_file
      @controller = Application.get_controller_and_action_name[:controller]
      @log.puts "E #{nowtime()} [#{$$}] < #{mail} > #{str} "
      @log.flush
    end

    private
  
    def nowtime
      now = Time.now
      str = sprintf( "%s:%06d", now.strftime("%Y/%m/%d %H:%M:%S"), now.usec )
      return str
    end
  
    def logfile_rename(logfile, num, size)
      if(File.exist?(logfile) == true)
        if(File.size(logfile) > size)
          num.step(1,-1){|i|
            oldlog = logfile + ".#{i-1}"
            newlog = logfile + ".#{i}"
            if(File.exist?(oldlog) == false)
              next
            end
            File.rename(oldlog,newlog)
          }
          log_bkp = logfile + ".0"
          File.rename(logfile,log_bkp)
        end
  
        fp = File.open( logfile, "a")
        fp.close
        File.chmod( 0777, logfile )
      else
        fp = File.open( logfile, "a")
        fp.close
        File.chmod( 0777, logfile )
      end
  
    rescue
      puts $!
      $@.each{|msg|
        puts msg
      }
    end
    
    def find_log_file
  
      log = $stdout
      controller = Application.get_controller_and_action_name[:controller]
      log_uri = Settings._settings[:server][:log_directory]
  
      if !File.exist?( log_uri )
        FileUtils.mkdir( log_uri )
      end
  
      tm_str = Time.now.utc.strftime( "%Y%m%d" )
      logfile = "#{log_uri}/#{controller}_controller.#{tm_str}.log"
  
      if(logfile == nil)
        logfile = File.basename(__FILE__) + ".log"
      end
      logfile_rename(logfile, 2, 10000000)
      log = open(logfile, "a")
      return log
    end
  end
end
