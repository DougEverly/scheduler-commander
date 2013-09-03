require 'rubygems'
require 'rufus-scheduler'
require 'socket'
require 'pp'
require 'terminal-table'
require_relative 'schedulable.rb'

class JobServer
  def initialize
    @port = 2000
    @server = TCPServer.new @port
    @count = 0;
    @cmds = ['list', 'add', 'delete', 'pause', 'resume', 'help', 'jobs']
    @valid_intervals = ['at', 'in', 'cron', 'every']
    @jobs = Hash.new
    @_jobs = Array.new
    @mutex = Mutex.new
  end
  
  def respond(client = nil, string = '')
    return if client.nil?
    client.puts "> #{string}"
  end
  
  def help(args = Array.new)
    "Valid commands: " + @cmds.join(', ')
  end
  
  def add(args = [])
    name = args.shift
    interval = args.shift
    value = args.shift
    _job = args.shift
    
    if not @valid_intervals.include?(interval)
      return "Invalid interval. Use #{@valid_intervals.join', '}."
    end
    
    
    
    if not _job
      return "No block defined"
    end
    
    
    klass = Module.const_get(_job.capitalize)
    return if not klass.is_a?(Class)
    
    puts "Found #{klass}"
    
    
    @mutex.synchronize {
      if @jobs.has_key? name
        return "Job #{name} alread exists. Remove it first"
      else
        puts "Adding #{name} #{interval} #{value} #{_job}"
        if interval == 'in'
          @jobs[name] = @scheduler.in(value, klass.new(args))
          @jobs[name].tags = name
        elsif interval == 'every'
          @jobs[name] = @scheduler.every(value, klass.new(args))
          @jobs[name].tags = name
            # @jobs[name] = @scheduler.every(value) do
            #   puts "Hi every #{value} #{name}"
            # end
        end
      end
    }
    "Added job #{name}"
  end

  def pause(args = [])
    name = args[0]
    puts "In pausejob to pause #{name}"
    @mutex.synchronize {
      if @jobs.has_key? name
        @jobs[name].pause
      else
        return "Job #{name} does not exist"
      end
    }
    "Paused job #{name}"
  end

  def resume(args = [])
    name = args[0]
    @mutex.synchronize {
      if @jobs.has_key? name
        @jobs[name].resume
      else
        return "Job #{name} does not exist"
      end
    }
    "Resumed job #{name}"
  end



  def delete(args = [])
    name = args[0]
    @mutex.synchronize {
      if @jobs.has_key? name
        puts "About to delete #{name}"
        puts @jobs[name]
        @jobs[name].unschedule
        @jobs.delete(name)
      else
        return "Job #{name} does not exist"
      end
    }
    "Deleted job #{name}"
  end

  def list(args = [])
    name = args[0]
    headings = Array.new
    rows = Array.new
    if name && (job = @scheduler.find_by_tag(name)[0]) then
      status = if job.paused? then
        "paused"
      else
        "running"
      end

      rows << ['Name', job.tags.join]
      rows << ['Status', status]
      rows << ['Interva''', job.schedule_info]
      rows << ['Last Run', job.last]
      rows << ['Next Run', job.next_time]
      return Terminal::Table.new :rows => rows
    else
      headings = ['Name', 'Status', 'Interval', 'Last Run', 'Next Run']
      @mutex.synchronize {
        @jobs.each_pair do |key, job|
          status = if job.paused? then
            "paused"
          else
            "running"
          end
          rows << [job.tags.join, status, job.schedule_info, job.last, job.next_time ]
        end
      }
      return Terminal::Table.new :rows => rows, :headings => headings

    end
  end

  def run
    @scheduler = Rufus::Scheduler.start_new
    puts "JobServer is running on port #{@port}"
    loop do
      @count += 1;
      puts "New thread #{@count}"
      Thread.new(@server.accept) do |client|
        until ('exit' == (cmd = client.gets.chomp)) do
          # client.puts '> ' + cmd
          # respond client, cmd
          cmd, *args = cmd.split ' '
          # send client, cmd
      
          if @cmds.include? cmd
            puts "sending #{cmd}"
            respond(client, self.send(cmd.to_sym, args))
          else
            respond client, "Invalid command: #{cmd}"
          end
        end
        respond client, 'bye'
        client.close
        Thread.exit!
      end
    end
  end

  def jobs(args = [])
    rows = []
    @mutex.synchronize do
      rows = @_jobs.map do  |klass|
        [ klass.to_s, klass.info]
        
      end
    end
    # rows.join
    return Terminal::Table.new :rows => rows
    # Terminal::Table.new :rows => rows
  end
  
  def register(klass)
    @mutex.synchronize {
      if klass.is_a?(Class) then
        puts "Registered #{klass.to_s}"
        @_jobs << klass;
      end
    }
  end

  def join
    @scheduler.join
  end
end


