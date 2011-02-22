Gem::Specification.new do |s|
  s.name        = "ruby-bulksms"
  s.version     = "0.4"
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Basayel Said"
  s.email       = "eng.basayel.said@gmail.com"
  s.homepage    = "http://github.com/basayel/ruby-bulksms"
  s.summary     = "Sending SMS using bulksms services"
  s.description = "Integrating SMS services into RubyOnRails applications using BulkSMS gateway"
  s.has_rdoc    = true

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end

