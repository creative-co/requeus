module Requeus
  class Railtie < Rails::Railtie
    rake_tasks do
      load 'tasks/requeus.rake'
    end

    initializer "requeus.initialize" do
      config_file = Rails.root.join("config", "requeus.yml")

      if config_file.file?
        Requeus.config_path = config_file
      end
    end
  end
end

