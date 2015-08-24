# Sample verbose configuration file for Unicorn (not Rack) 
# 
# This configuration file documents many features of Unicorn 
# that may not be needed for some applications. See 
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb 
# for a much simpler configuration file. 
# 
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete 
# documentation. 
 
# Set the current app's path for later reference. Rails.root isn't available at
# this point, so we have to point up a directory.
app_path = File.expand_path(File.dirname(__FILE__) + '/..')

 
# Use at least one worker per core if you're on a dedicated server, 
# more will usually help for _short_ waits on databases/caches. 
worker_processes 4 
 
 
# Since Unicorn is never exposed to outside clients, it does not need to 
# run on the standard HTTP port (80), there is no reason to start Unicorn 
# as root unless it's from system init scripts. 
# If running the master process as root and the workers as an unprivileged 
# user, do this to switch euid/egid in the workers (also chowns logs): 
# user "unprivileged_user", "unprivileged_group" 
 
 
# Help ensure your application will always spawn in the symlinked 
# "current" directory that Capistrano sets up. 
# ay remmed ... working_directory "/path/to/app/current" # available in 0.94.0+ 
 
# Set the working directory of this unicorn instance.
working_directory app_path

 
# You can listen on a port or a socket. Listening on a socket is good in a
# production environment, but listening on a port can be useful for local
# debugging purposes.
listen app_path + '/tmp/unicorn.sock', backlog: 64

# For development, you may want to listen on port 3000 so that you can make sure
# your unicorn.rb file is soundly configured.
listen(3000, backlog: 64) if ENV['RAILS_ENV'] == 'development' 
 
# nuke workers after 30 seconds instead of 60 seconds (the default) 
timeout 300
 
 
# feel free to point this anywhere accessible on the filesystem 
# ay remmed ... pid "/path/to/app/shared/pids/unicorn.pid" 
 
#Set the location of the unicorn pid file. This should match what we put in the
# unicorn init script later.
pid app_path + '/tmp/unicorn.pid'


# By default, the Unicorn logger will write to stderr. 
# youu should define your stderr and stdout here. If you don't, stderr defaults
# to /dev/null and you'll lose any error logging when in daemon mode.
stderr_path app_path + '/log/unicorn.log'
stdout_path app_path + '/log/unicorn.log'
 
# combine Ruby 2.0.0dev or REE with "preload_app true" for memory savings 
# http://rubyenterpriseedition.com/faq.html#adapt_apps_for_cow 
preload_app true 
GC.respond_to?(:copy_on_write_friendly=) and 
  GC.copy_on_write_friendly = true 
 
 
# Enable this flag to have unicorn test client connections by writing the 
# beginning of the HTTP headers before calling the application.  This 
# prevents calling the application for connections that have disconnected 
# while queued.  This is only guaranteed to detect clients on the same 
# host unicorn runs on, and unlikely to detect disconnects even on a 
# fast LAN. 
check_client_connection false 
 
before_fork do |server, worker| 
  # the following is highly recomended for Rails + "preload_app true" 
  # as there's no need for the master process to hold a connection 
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.connection.disconnect! 

 
  # The following is only recommended for memory/DB-constrained 
  # installations.  It is not needed if your system can house 
  # twice as many worker_processes as you have configured. 
  # 
  # # This allows a new master process to incrementally 
  # # phase out the old master process with SIGTTOU to avoid a 
  # # thundering herd (especially in the "preload_app false" case) 
  # # when doing a transparent upgrade.  The last worker spawned 
  # # will then kill off the old master process with a SIGQUIT. 
  # old_pid = "#{server.config[:pid]}.oldbin" 
  # if old_pid != server.pid 
  #   begin 
  #     sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU 
  #     Process.kill(sig, File.read(old_pid).to_i) 
  #   rescue Errno::ENOENT, Errno::ESRCH 
  #   end 
  # end 
  # 
  # Throttle the master from forking too quickly by sleeping.  Due 
  # to the implementation of standard Unix signal handlers, this 
  # helps (but does not completely) prevent identical, repeated signals 
  # from being lost when the receiving process is busy. 
  # sleep 1 
end 

 
after_fork do |server, worker| 
  # per-process listener ports for debugging/admin/migrations 
  # addr = "127.0.0.1:#{9293 + worker.nr}" 
  # server.listen(addr, :tries => -1, :delay => 5, :tcp_nopush => true) 

 
  # the following is *required* for Rails + "preload_app true", 
  defined?(ActiveRecord::Base) and 
    ActiveRecord::Base.establish_connection 

 
  # if preload_app is true, then you may also want to check and 
  # restart any other shared sockets/descriptors such as Memcached, 
  # and Redis.  TokyoCabinet file handles are safe to reuse 
  # between any number of forked children (assuming your kernel 
  # correctly implements pread()/pwrite() system calls) 
end 
