module References
  class WeakReference
    # This implementation can be used for testing. It implements the proper interface,
    # but allows for mimicking garbage collection on demand.
    class TestImpl
      @@object_list = {}

      def initialize(obj)
        @object = obj
        @@object_list[obj.__id__] = true
        ObjectSpace.define_finalizer(self, lambda{@@object_list.delete(obj.__id__)})
      end

      def object
        if @@object_list.include?(@object.__id__)
          @object
        else
          @object = nil
        end
      end
      
      class << self
        # Use the test implementation inside a block and then restore the original implementation.
        def use
          save_implementation = WeakReference.implementation
          WeakReference.implementation = self
          begin
            yield
          ensure
            WeakReference.implementation = save_implementation
          end
        end

        # Simulate garbage collection of the objects passed in as arguments. If no objects
        # are specified, all objects will be reclaimed.
        def gc(*objects)
          if objects.empty?
            @@object_list = {}
          else
            objects.each{|obj| @@object_list.delete(obj.__id__)}
          end
        end
      end
    end
  end
end
