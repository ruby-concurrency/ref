require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/gempackagetask'
require File.expand_path('../lib/ref', __FILE__)

desc 'Default: run unit tests.'
task :default => :test

desc 'RVM likes to call it tests'
task :tests => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--title' << 'Ref' << '--line-numbers' << '--inline-source' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = eval(File.read(File.expand_path('../ref.gemspec', __FILE__)))

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end
Rake.application["package"].prerequisites.unshift("java:build")

desc "Release to rubygems.org"
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end

namespace :java do
  desc "Build the jar files for Jruby support"
  task :build do
    base_dir = File.dirname(__FILE__)
    tmp_dir = File.join(base_dir, "tmp")
    classes_dir = File.join(tmp_dir, "classes")
    jar_dir = File.join(base_dir, "lib", "org", "jruby", "ext", "ref")
    FileUtils.rm_rf(classes_dir)
    ext_dir = File.join(base_dir, "ext", "java")
    source_files = FileList["#{base_dir}/**/*.java"]
    jar_file = File.join(jar_dir, 'references.jar')
    # Only build if any of the source files have changed
    up_to_date = File.exist?(jar_file) && source_files.all?{|f| File.mtime(f) <= File.mtime(jar_file)}
    unless up_to_date
      FileUtils.mkdir_p(classes_dir)
      `#{ENV['JAVA_HOME']}/bin/javac -classpath '#{"#{ENV['JRUBY_HOME']}/lib/jruby.jar"}' -d '#{classes_dir}' -sourcepath '#{ext_dir}' '#{source_files.join("' '")}'`
      if $? == 0
        FileUtils.rm_rf(jar_dir) if File.exist?(jar_dir)
        FileUtils.mkdir_p(jar_dir)
        `#{ENV['JAVA_HOME']}/bin/jar cf '#{jar_file}' -C '#{classes_dir}' org`
      end
      FileUtils.rm_rf(classes_dir)
    end
  end
end

namespace :test do
  namespace :performance do
    desc "Run a speed test on how long it takes to create 100000 weak references"
    task :weak_reference do
      puts "Testing performance of weak references..."
      t = Time.now
      Process.fork do
        100000.times do
          Ref::WeakReference.new(Object.new)
        end
      end
      Process.wait
      puts "Creating 100,000 weak references took #{Time.now - t} seconds"
    end
    
    desc "Run a speed test on how long it takes to create 100000 soft references"
    task :soft_reference do
      puts "Testing performance of soft references..."
      t = Time.now
      100000.times do |i|
        Ref::SoftReference.new(Object.new)
      end
      GC.start
      GC.start
      puts "Creating 100,000 soft references took #{Time.now - t} seconds"
    end
  end
end
