Gem::Specification.new do |s|
  s.name = 'references'
  s.version = File.read(File.expand_path("../VERSION", __FILE__)).strip
  s.summary = "Library that implements weak, soft, and strong references in Ruby."
  s.description = "Library that implements weak, soft, and strong references in Ruby that work across multiple runtimes (MRI, REE, YARV, Jruby, Rubinius, and IronRuby). Also includes implementation of maps/hashes that use references and a reference queue."

  s.authors = ['Brian Durand']
  s.email = ['bdurand@embellishedvisions.com']
  s.homepage = "http://github.com/bdurand/references"

  s.files = ['README.rdoc', 'VERSION'] +  Dir.glob('lib/**/*'), Dir.glob('test/**/*'), Dir.glob('ext/**/*')
  s.require_path = 'lib'
  
  s.has_rdoc = true
  s.rdoc_options = ["--charset=UTF-8", "--main", "README.rdoc"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
end
