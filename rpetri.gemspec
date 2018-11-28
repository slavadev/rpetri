lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rpetri/version'

Gem::Specification.new do |spec|
  spec.name          = 'rpetri'
  spec.version       = Rpetri::VERSION
  spec.authors       = ['korolvs']
  spec.email         = ['korolvs@gmail.com']

  spec.summary       = 'Testing ruby code with Petri nets'
  spec.description   = 'Testing ruby code with Petri nets'
  spec.homepage      = 'http://korolvs.com'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'bin'
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-configurable', '~> 0.7.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'factory_bot', '~> 4.10.0'
  spec.add_development_dependency 'faker', '~> 1.8.7'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
