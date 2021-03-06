Capistrano::Configuration.instance(:must_exist).load do
  namespace :unicorn do
    def self.command_name
      command_name = rails_version =~ /^3.*/ ? "unicorn" : "unicorn_rails"
    end

    def self.master_pid
      pid = capture "pid=$(ps aux | grep #{command_name} | grep master | grep -v '(old)' | grep -v grep | grep #{current_path}); echo $pid"

      unless pid.empty?
        pid.split(" ")[1]
      end
    end

    def self.old_master_pid
      pid = capture "pid=$(ps aux | grep #{command_name} | grep master | grep '(old)' | grep -v grep | grep #{current_path}); echo $pid"

      unless pid.empty?
        pid.split(" ")[1]
      end
    end

    desc "Start unicorn"
    task :start do
      run "#{command_name} -D -E #{rails_env} -c #{current_path}/config/unicorn/#{rails_env}.rb"
    end

    desc "Restart unicorn"
    task :restart do
      if pid = master_pid
        run "kill -s USR2 #{pid}"

        loop do
          puts "Searching for newly spawned master process..."

          if pid = master_pid
            puts "Found new master process..."

            if old_pid = old_master_pid
              run "kill -s WINCH #{old_pid}"
              run "kill -s QUIT  #{old_pid}"
            end

            break
          end

          sleep 1
        end
      end
    end

    desc "Stop unicorn"
    task :stop do
      if pid = master_pid
        run "kill -s TERM #{pid}"
      end
    end
  end

  namespace :deploy do
    desc "Start the unicorn workers"
    task :start do
      unicorn.start
    end

    desc "Stop the unicorn workers"
    task :stop do
      unicorn.stop
    end

    desc "Restart the unicorn workers"
    task :restart do
      unicorn.restart
    end
  end
end