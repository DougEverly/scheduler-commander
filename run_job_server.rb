#!/usr/bin/env ruby

require_relative "lib/job_server"

s = JobServer.new
s.register(Work)
s.register(Looper)
s.run



