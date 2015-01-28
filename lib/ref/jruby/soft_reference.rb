module Ref

  class SoftReference < Reference
    def initialize(obj)
      @_ref = java.lang.ref.SoftReference.new(obj)
      @referenced_object_id = obj.__id__
    end

    def object
      @_ref.get()
    end
  end
end
