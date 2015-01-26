require_relative 'test_helper'

class TestWeakValueMap < Test::Unit::TestCase
  include ReferenceValueMapBehavior
  
  def map_class
    Ref::WeakValueMap
  end
  
  def reference_class
    Ref::WeakReference
  end
end
