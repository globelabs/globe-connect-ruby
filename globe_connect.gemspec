# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'globe_connect/version'

Gem::Specification.new do |spec|
  spec.name          = "globe_connect"
  spec.version       = GlobeConnect::VERSION
  spec.authors       = ["Rico Maglayon"]
  spec.email         = ["rmaglayon@gmail.com"]

  spec.summary       = %q{Globe Connect for Ruby.}
  spec.description   = %q{Globe Connect for Ruby platform provides an implementation of Globe APIs e.g Authentication, Amax,
  Sms etc. that is easy to use and can be integrated in your existing Ruby application. Below shows
  some samples on how to use the API depending on the functionality that you need to integrate in your
  application.}
  spec.homepage      = "http://globelabs.com.ph"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "http://mygemserver.com"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.0'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
