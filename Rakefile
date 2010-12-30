require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'rake/gempackagetask'
require File.expand_path('../lib/references', __FILE__)

desc 'Default: run unit tests.'
task :default => :test

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.warning = true
  t.verbose = true
end

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.options << '--title' << 'References' << '--line-numbers' << '--inline-source' << '--main' << 'README.rdoc'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

spec = eval(File.read(File.expand_path('../references.gemspec', __FILE__)))

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
    FileUtils.rm_rf(classes_dir)
    ext_dir = File.join(base_dir, "ext", "java")
    source_files = FileList["#{base_dir}/**/*.java"]
    FileUtils.mkdir_p(classes_dir)
    `#{ENV['JAVA_HOME']}/bin/javac -classpath '#{"#{ENV['JRUBY_HOME']}/lib/jruby.jar"}' -d '#{classes_dir}' -sourcepath '#{ext_dir}' '#{source_files.join("' '")}'`
    `#{ENV['JAVA_HOME']}/bin/jar cf '#{base_dir}/lib/references/java_support.jar' -C '#{classes_dir}' references`
    FileUtils.rm_rf(classes_dir)
  end
end

namespace :test do
  namespace :performance do
    desc "Run a speed test on how long it takes to create 100000 weak references"
    task :weak_reference do
      puts "Testing performance of weak references..."
      t = Time.now
      100000.times do
        References::WeakReference.new(Object.new)
      end
      puts "Creating 100,000 weak references took #{Time.now - t} seconds"
    end
    
    desc "Run a speed test on how long it takes to create 100000 soft references"
    task :soft_reference do
      puts "Testing performance of soft references..."
      t = Time.now
      100000.times do |i|
        References::SoftReference.new(Object.new)
      end
      puts "Creating 100,000 soft references took #{Time.now - t} seconds"
    end
  end
end
