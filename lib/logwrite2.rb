#!/usr/bin/ruby

class LogWrite2

  @log = $stdout

  def initialize( logfile=nil, num=2, size=1000000 )

    if(logfile == nil)
      logfile = File.basename(__FILE__) + ".log"
    end
    logfile_rename(logfile, num, size)
    @log = open(logfile,"a")
    @log.puts "***** Logging start at #{nowtime} pid=#{$$} *****"
  end

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

  def write(str)
    @log.puts "? #{nowtime()} : [#{$$}] #{str}"
    @log.flush
  end

  def info(str)
    @log.puts "I #{nowtime()} : [#{$$}] #{str}"
    @log.flush
  end

  def warn(str)
    @log.puts "W #{nowtime()} : [#{$$}] #{str}"
    @log.flush
  end

  def error(str)
    @log.puts "E #{nowtime()} : [#{$$}] #{str}"
    @log.flush
  end

  def exit
    @log.close
  end
end
