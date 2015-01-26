$:.push File.join(File.dirname(__FILE__), 'lib')

require 'ref/version'

Gem::Specification.new do |s|
  s.name        = 'ref'
  s.version     = Ref::VERSION
  s.authors     = ['Brian Durand']
  s.email       = ['bbdurand@gmail.com']
  s.homepage    = "http://github.com/ruby-concurrency/ref"
  s.summary     = "Library that implements weak, soft, and strong references in Ruby."
  s.description = "Library that implements weak, soft, and strong references in Ruby that work across multiple runtimes (MRI, REE, YARV, Jruby, Rubinius, and IronRuby). Also includes implementation of maps/hashes that use references and a reference queue."
  s.license     = "MIT"
  s.date        = Time.now.strftime('%Y-%m-%d')

  s.files         = ['README.md', 'MIT_LICENSE']
  s.files        += Dir['lib/**/*.*']
  s.files        += Dir['ext/**/*.*']
  s.files        += Dir['test/**/*.*']

  s.require_paths = ['lib']
  
  s.has_rdoc         = true
  s.rdoc_options     = ["--charset=UTF-8", "--main", "README.md"]
  s.extra_rdoc_files = ["README.md"]

  s.required_ruby_version = '>= 1.9.3'
end
