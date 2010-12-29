require 'weakref'

module References
  class WeakReference
    # This implementation of a weak reference simply wraps the standard WeakRef implementation
    # that comes with Ruby.
    class WeakRefImpl
      def initialize(obj)
        @ref = ::WeakRef.new(obj)
      end

      def object
        @ref.__getobj__
      rescue => e
        # Jruby implementation uses RefError while MRI uses WeakRef::RefError
        if (defined?(RefError) && e.is_a?(RefError)) || (defined?(::WeakRef::RefError) && e.is_a?(::WeakRef::RefError))
          nil
        else
          raise e
        end
      end
    end
  end
end
