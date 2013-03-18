require 'rake'
require 'rake/testtask'
require 'rubygems/package_task'
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

spec = eval(File.read(File.expand_path('../ref.gemspec', __FILE__)))

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
end
Rake.application["package"].prerequisites.unshift("java:build")
Rake.application["package"].prerequisites.unshift("rbx:delete_rbc_files")

desc "Release to rubygems.org"
task :release => [:package, "gem:push"]

namespace :java do
  desc "Build the jar files for Jruby support. You must set your JRUBY_HOME environment variable to the root of your jruby install."
  task :build do
    base_dir = File.dirname(__FILE__)
    tmp_dir = File.join(base_dir, "tmp")
    classes_dir = File.join(tmp_dir, "classes")
    jar_dir = File.join(base_dir, "lib", "org", "jruby", "ext", "ref")
    FileUtils.rm_rf(classes_dir)
    ext_dir = File.join(base_dir, "ext", "java")
    source_files = FileList["#{base_dir}/ext/**/*.java"]
    jar_file = File.join(jar_dir, 'references.jar')
    # Only build if any of the source files have changed
    up_to_date = File.exist?(jar_file) && source_files.all?{|f| File.mtime(f) <= File.mtime(jar_file)}
    unless up_to_date
      FileUtils.mkdir_p(classes_dir)
      puts "#{ENV['JAVA_HOME']}/bin/javac -target 1.5 -classpath '#{"#{ENV['JRUBY_HOME']}/lib/jruby.jar"}' -d '#{classes_dir}' -sourcepath '#{ext_dir}' '#{source_files.join("' '")}'"
      `#{ENV['JAVA_HOME']}/bin/javac -target 1.5 -classpath '#{"#{ENV['JRUBY_HOME']}/lib/jruby.jar"}' -d '#{classes_dir}' -sourcepath '#{ext_dir}' '#{source_files.join("' '")}'`
      if $? == 0
        FileUtils.rm_rf(jar_dir) if File.exist?(jar_dir)
        FileUtils.mkdir_p(jar_dir)
        `#{ENV['JAVA_HOME']}/bin/jar cf '#{jar_file}' -C '#{classes_dir}' org`
      end
      FileUtils.rm_rf(classes_dir)
    end
  end
end

namespace :rbx do
  desc "Cleanup *.rbc files in lib directory"
  task :delete_rbc_files do
    FileList["lib/**/*.rbc"].each do |rbc_file|
      File.delete(rbc_file)
    end
    nil
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
      100000.times do
        Ref::SoftReference.new(Object.new)
      end
      GC.start
      GC.start
      puts "Creating 100,000 soft references took #{Time.now - t} seconds"
    end
  end
end
