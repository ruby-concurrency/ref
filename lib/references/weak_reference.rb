module References
  # A WeakReference represents a reference to an object that is not seen by
  # the tracing phase of the garbage collector. This allows the referenced
  # object to be garbage collected as if nothing is referring to it.
  #
  # === Example usage:
  #
  #   foo = Object.new
  #   ref = References::WeakReference.new(foo)
  #   ref.object			# should be foo
  #   ObjectSpace.garbage_collect
  #   ref.object			# should be nil
  #
  # === Implementations
  #
  # Because the different Ruby VM's have different memory management schemes, this class
  # serves as a common interface to a variety of weak reference implementations. The best
  # implementation will be set automatically depending on which Ruby runtime is being used.
  # The available implementations are:
  #
  # * RubyImpl - a pure Ruby implementation compatible with MRI, REE, and YARV
  # * JavaImpl - a native Java implementation for use with Jruby
  # * IronRubyImpl - an implementation that uses IronRuby specific classes
  # * WeakRefImpl - an implementation built on top of WeakRef from the standard library
  class WeakReference < Reference
    autoload :RubyImpl, File.join(File.dirname(__FILE__), "weak_reference", "ruby_impl.rb")
    autoload :IronRubyImpl, File.join(File.dirname(__FILE__), "weak_reference", "iron_ruby_impl.rb")
    autoload :WeakRefImpl, File.join(File.dirname(__FILE__), "weak_reference", "weak_ref_impl.rb")
    autoload :TestImpl, File.join(File.dirname(__FILE__), "weak_reference", "test_impl.rb")
    
    class << self
      # Get the implementation class for weak references.
      def implementation
        @implementation
      end

      # Set the implementation class for weak references.
      def implementation=(klass)
        @implementation = klass
      end
    end
    
    # Create a weak reference to an object.
    def initialize(obj)
      @referenced_object_id = obj.__id__
      @ref = self.class.implementation.new(obj)
    end

    # Get the referenced object. If the object has been reclaimed by the
    # garbage collector, then this will return nil.
    def object
      @ref.object
    end
  end
end
