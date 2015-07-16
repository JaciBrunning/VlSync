# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'VlSync/version'

Gem::Specification.new do |spec|
  spec.name          = "vlsync"
  spec.version       = VlSync::VERSION
  spec.authors       = ["Jaci R"]
  spec.email         = ["jaci.brunning@gmail.com"]

  spec.summary       = %q{Sync VLC playback across multiple computers}
  spec.homepage      = "http://www.github.com/JacisNonsense/VlSync"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.bindir        = "bin"
  spec.files = Dir.glob("lib/**/*") + ['Rakefile', 'VlSync.gemspec', 'Gemfile', 'Rakefile']
  spec.executables   = ["vlsync"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
