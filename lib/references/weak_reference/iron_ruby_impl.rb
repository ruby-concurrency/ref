module References
  class WeakReference
    # This implementation of a weak reference wraps the System::WeakReference class
    # that comes with IronRuby.
    class IronRubyImpl
      def initialize(obj)
        @ref = ::System::WeakReference.new(obj)
      end

      def object
        @ref.target
      end
    end
  end
end
