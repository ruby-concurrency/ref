require 'monitor'

module References
  autoload :AbstractReferenceValueMap, File.join(File.dirname(__FILE__), "references", "abstract_reference_value_map.rb")
  autoload :AbstractReferenceKeyMap, File.join(File.dirname(__FILE__), "references", "abstract_reference_key_map.rb")
  autoload :Mock, File.join(File.dirname(__FILE__), "references", "mock.rb")
  autoload :Reference, File.join(File.dirname(__FILE__), "references", "reference.rb")
  autoload :ReferenceQueue, File.join(File.dirname(__FILE__), "references", "reference_queue.rb")
  autoload :SoftKeyMap, File.join(File.dirname(__FILE__), "references", "soft_key_map.rb")
  autoload :SoftValueMap, File.join(File.dirname(__FILE__), "references", "soft_value_map.rb")
  autoload :StrongReference, File.join(File.dirname(__FILE__), "references", "strong_reference.rb")
  autoload :WeakKeyMap, File.join(File.dirname(__FILE__), "references", "weak_key_map.rb")
  autoload :WeakValueMap, File.join(File.dirname(__FILE__), "references", "weak_value_map.rb")

  # Set the best implementation for weak references based on the runtime.
  if defined?(RUBY_PLATFORM) && RUBY_PLATFORM == 'java'
    # Use native Java references
    begin
      $LOAD_PATH.unshift(File.dirname(__FILE__))
      require 'org/jruby/ext/references/reference'
    ensure
      $LOAD_PATH.shift if $LOAD_PATH.first == File.dirname(__FILE__)
    end
  else
    autoload :SoftReference, File.join(File.dirname(__FILE__), "references", "soft_reference.rb")
    if defined?(RUBY_ENGINE) && RUBY_ENGINE == 'ironruby'
      # IronRuby has it's own implementation of weak references.
      autoload :WeakReference, File.join(File.dirname(__FILE__), "references", "weak_reference", "iron_ruby.rb")
    elsif defined?(RUBY_ENGINE) && RUBY_ENGINE == 'rbx'
      # If using Rubinius set the implementation to use WeakRef since it is very efficient.
      autoload :WeakReference, File.join(File.dirname(__FILE__), "references", "weak_reference", "weak_ref.rb")
    elsif defined?(ObjectSpace._id2ref)
      # If ObjectSpace can lookup objects from their object_id, then use the pure ruby implementation.
      autoload :WeakReference, File.join(File.dirname(__FILE__), "references", "weak_reference", "pure_ruby.rb")
    else
      # Otherwise, wrap the standard library WeakRef class
      autoload :WeakReference, File.join(File.dirname(__FILE__), "references", "weak_reference", "weak_ref.rb")
    end
  end
end
