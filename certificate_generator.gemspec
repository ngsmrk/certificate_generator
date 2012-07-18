# -*- encoding: utf-8 -*-
require File.expand_path('../lib/certificate_generator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors     = [" Angus Mark"]
  gem.email       = ["ngsmrk@gmail.com"]
  gem.homepage    = "http://github.com/ngsmrk/certificate_generator"
  gem.summary     = %q{Gem that handles generation of self-signed SSL certs}
  gem.description = %q{See summary}

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "certificate_generator"
  gem.require_paths = ["lib"]
  gem.version       = CertificateGenerator::VERSION
end
