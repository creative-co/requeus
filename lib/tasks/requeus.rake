require 'daemons'

def requeus_main cmd
  pwd = `pwd`.strip

  opts = {
      :dir_mode => :normal,
      :dir => File.join(pwd, 'tmp/pids'),
      :log_output => true,
      :ARGV => [cmd]
  }

  Daemons.run_proc('requeus', opts) do
    Requeus.config_path = File.join(pwd, 'config/requeus.yml')
    Requeus.start_workers
  end
end

namespace :requeus do
  %w(start stop run).each do |cmd|
    desc cmd
    task cmd do
      requeus_main cmd
    end
  end
end
