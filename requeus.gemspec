# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{requeus}
  s.version = "0.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ilia Ablamonov", "Anatoliy Plastinin", "Cloud Castle Inc."]
  s.date = %q{2011-05-04}
  s.description = %q{requeus gem is a library for proxying requests}
  s.email = %q{antlypls@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE.txt",
    "README.rdoc",
    "lib/requeus.rb",
    "lib/requeus/adapter/filesystem.rb",
    "lib/requeus/adapter/rabbit.rb",
    "lib/requeus/adapter/s3.rb",
    "lib/requeus/adapter/sqs.rb",
    "lib/requeus/adapters.rb",
    "lib/requeus/blob_store.rb",
    "lib/requeus/impl.rb",
    "lib/requeus/queue.rb",
    "lib/requeus/railtie.rb",
    "lib/requeus/request.rb",
    "lib/requeus/server.rb",
    "lib/tasks/requeus.rake",
    "requeus.gemspec"
  ]
  s.homepage = %q{http://github.com/antlypls/requeus}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.2}
  s.summary = %q{requeus}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<carrot>, ["~> 0.8.1"])
      s.add_runtime_dependency(%q<aws>, ["~> 2.3.34"])
      s.add_runtime_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_runtime_dependency(%q<multipart-post>, ["~> 1.1.0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<carrot>, ["~> 0.8.1"])
      s.add_dependency(%q<aws>, ["~> 2.3.34"])
      s.add_dependency(%q<daemons>, ["~> 1.0.10"])
      s.add_dependency(%q<multipart-post>, ["~> 1.1.0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<carrot>, ["~> 0.8.1"])
    s.add_dependency(%q<aws>, ["~> 2.3.34"])
    s.add_dependency(%q<daemons>, ["~> 1.0.10"])
    s.add_dependency(%q<multipart-post>, ["~> 1.1.0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end
