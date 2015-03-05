# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'changelog_merger/version'

Gem::Specification.new do |spec|
  spec.name          = 'changelog_merger'
  spec.default_executable = 'changelog_merger'
  spec.version       = ChangelogMerger::VERSION
  spec.authors       = ['Petr Korolev']
  spec.email         = ['sky4winder@gmail.com']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = ''
  end

  spec.summary       = %q{Script to merge change logs to github repo}
  spec.description   = %q{Script to merge change logs to github repo}
  spec.homepage      = 'https://github.com/skywinder/ChangelogMerger'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency(%q<github_api>, ["~> 0.12"])
  spec.add_runtime_dependency(%q<colorize>, ["~> 0.7"])
  spec.add_runtime_dependency "github_changelog_generator", "~> 1.3.4"
end
