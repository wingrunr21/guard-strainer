# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/strainer/version'

Gem::Specification.new do |spec|
  spec.name          = 'guard-strainer'
  spec.version       = Guard::StrainerVersion::VERSION
  spec.authors       = ['Stafford Brunk']
  spec.email         = ['stafford.brunk@gmail.com']
  spec.description   = %q{Watch for changes in your chef-repo or cookbook and automatically run strainer}
  spec.summary       = %q{guard-strainer will automatically execute a Strainerfile for a watched chef-repo or cookbook when it detects changes}
  spec.homepage      = 'https://github.com/wingrunr21/guard-strainer'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'guard', '>= 1.8.0'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.13.0'
  spec.add_development_dependency 'simplecov', '~> 0.7.1'
end
