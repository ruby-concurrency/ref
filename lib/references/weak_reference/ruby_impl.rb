module References
  # This is a pure ruby implementation of a weak reference. It is much more
  # efficient than the bundled WeakRef implementation because it does not
  # subclass Delegator which is very heavy to instantiate and utilizes a
  # fair amount of memory.
  #
  # This implementation cannot be used by Jruby if ObjectSpace has been
  # disabled.
  class WeakReference
    class RubyImpl
      # Map of references to the object_id's they refer to.
      @@referenced_object_ids = {}

      # Map of object_ids to references to them.
      @@object_id_references = {}

      @@monitor = Monitor.new
      
      # Finalizer that cleans up weak references when an object is destroyed.
      @@object_finalizer = lambda do |object_id|
        reference_ids = @@object_id_references[object_id]
        if reference_ids
      	  reference_ids.each do |reference_object_id|
      	    @@referenced_object_ids.delete(reference_object_id)
      	  end
      	  @@object_id_references.delete(object_id)
    	  end
      end

      # Finalizer that cleans up weak references when references are destroyed.
      @@reference_finalizer = lambda do |object_id|
        referenced_id = @@referenced_object_ids.delete(object_id)
        if referenced_id
          obj = ObjectSpace._id2ref(referenced_id) rescue nil
          if obj
            backreferences = obj.instance_variable_get(:@__weak_backreferences__) if obj.instance_variable_defined?(:@__weak_backreferences__)
            if backreferences
              backreferences.delete(object_id)
              obj.remove_instance_variable(:@__weak_backreferences__) if backreferences.empty?
            end
          end
          references = @@object_id_references[referenced_id]
          if references
            references.delete(object_id)
        	  @@object_id_references.delete(referenced_id) if references.empty?
      	  end
    	  end
      end

      # Create a new weak reference to an object. The existence of the weak reference
      # will not prevent the garbage collector from reclaiming the referenced object.
      def initialize(obj)
        @referenced_object_id = obj.__id__
        ObjectSpace.define_finalizer(obj, @@object_finalizer)
        ObjectSpace.define_finalizer(self, @@reference_finalizer)
        disabled = GC.disable
        begin
          @@monitor.synchronize do
            @@referenced_object_ids[self.__id__] = obj.__id__
            add_backreference(obj)
            references = @@object_id_references[obj.__id__]
            unless references
              references = []
              @@object_id_references[obj.__id__] = references
            end
            references.push(self.__id__)
          end
        ensure
          GC.enable unless disabled
        end
      end

      # Get the reference object. If the object has already been garbage collected,
      # then this method will return nil.
      def object
        obj = nil
        begin
          if @referenced_object_id == @@referenced_object_ids[self.object_id]
            obj = ObjectSpace._id2ref(@referenced_object_id)
            obj = nil unless verify_backreferences(obj)
          end
        rescue RangeError
          # Object has been garbage collected.
        end
        obj
      end

      private

        def add_backreference(obj) #:nodoc:
          backreferences = obj.instance_variable_get(:@__weak_backreferences__) if obj.instance_variable_defined?(:@__weak_backreferences__)
          unless backreferences
            backreferences = []
            obj.instance_variable_set(:@__weak_backreferences__, backreferences)
          end
          backreferences << object_id
        end

        def verify_backreferences(obj) #:nodoc:
          backreferences = obj.instance_variable_get(:@__weak_backreferences__) if obj.instance_variable_defined?(:@__weak_backreferences__)
          backreferences && backreferences.include?(object_id)
        end
    end
  end
end
