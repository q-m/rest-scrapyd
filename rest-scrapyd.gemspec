Gem::Specification.new do |s|
  s.name        = 'rest-scrapyd'
  s.version     = '0.1.1'
  s.date        = '2015-02-21'
  s.authors     = ['wvengen']
  s.email       = 'dev-rails@willem.engen.nl'
  s.summary     = 'REST client for the Scrapyd API'
  s.description = 'REST client for the Scrapyd API, built with rest-core.'
  s.homepage    = 'https://github.com/wvengen/rest-scrapyd'
  s.license     = 'MIT'

  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files            = Dir["lib/**/*"] + s.extra_rdoc_files
  s.test_files       = s.files.grep(%r[^test/])

  s.require_paths    = ["lib"]
  s.rdoc_options     = ["--charset=UTF-8"]

  s.add_dependency(%q<rest-core>, [">= 3.3.0"])
end
