require 'monitor'

module References
  autoload :AbstractReferenceValueMap, File.join(File.dirname(__FILE__), "references", "abstract_reference_value_map.rb")
  autoload :AbstractReferenceKeyMap, File.join(File.dirname(__FILE__), "references", "abstract_reference_key_map.rb")
  autoload :Reference, File.join(File.dirname(__FILE__), "references", "reference.rb")
  autoload :ReferenceQueue, File.join(File.dirname(__FILE__), "references", "reference_queue.rb")
  autoload :SoftKeyMap, File.join(File.dirname(__FILE__), "references", "soft_key_map.rb")
  autoload :SoftValueMap, File.join(File.dirname(__FILE__), "references", "soft_value_map.rb")
  autoload :StrongReference, File.join(File.dirname(__FILE__), "references", "strong_reference.rb")
  autoload :WeakReference, File.join(File.dirname(__FILE__), "references", "weak_reference.rb")
  autoload :WeakKeyMap, File.join(File.dirname(__FILE__), "references", "weak_key_map.rb")
  autoload :WeakValueMap, File.join(File.dirname(__FILE__), "references", "weak_value_map.rb")

  # Set the best implementation for weak references based on the runtime.
  if defined?(RUBY_PLATFORM) && RUBY_PLATFORM == 'java'
    begin
      $LOAD_PATH.unshift(File.dirname(__FILE__))
      require 'references/java_support'
      WeakReference.implementation = WeakReference::JavaImpl
    ensure
      $LOAD_PATH.shift if $LOAD_PATH.first == File.dirname(__FILE__)
    end
  else
    autoload :SoftReference, File.join(File.dirname(__FILE__), "references", "soft_reference.rb")
    if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'
      WeakReference.implementation = WeakReference::IronRubyImpl
    elsif defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
      # If using Rubinius set the implementation to use WeakRef since it is very efficient.
      require 'weakref'
      WeakReference.implementation = WeakReference::WeakRefImpl
    else
      WeakReference.implementation = WeakReference::RubyImpl
    end
  end
end
