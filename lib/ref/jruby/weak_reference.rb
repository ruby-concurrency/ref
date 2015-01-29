module Ref
  class WeakReference < Reference

    def initialize(obj)
      @_ref = java.lang.ref.WeakReference.new(obj)
      @referenced_object_id = obj.__id__
    end

    def object
      @_ref.get()
    end

  end

end
