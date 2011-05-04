require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "requeus"
  gem.homepage = "http://github.com/antlypls/requeus"
  gem.license = "MIT"
  gem.summary = %Q{requeus}
  gem.description = %Q{requeus gem is a library for proxying requests}
  gem.email = "antlypls@gmail.com"
  gem.authors = ["Ilia Ablamonov", "Anatoliy Plastinin", "Cloud Castle Inc."]

  gem.files = FileList['lib/**/*.*', 'LICENSE.txt', 'README.rdoc', 'requeus.gemspec']

  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)

  #see gem file for dependencies
  #gem.add_runtime_dependency 'aws', '~> 2.3.34'
  #gem.add_runtime_dependency 'carrot', '~> 0.8.1'
  #gem.add_runtime_dependency 'daemons', '~> 1.0.10'
  #gem.add_runtime_dependency 'multipart-post', '~> 1.1.0'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "requeus #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
