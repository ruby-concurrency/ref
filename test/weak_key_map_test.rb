require_relative 'test_helper'

class TestWeakKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    Ref::WeakKeyMap
  end
  
  def reference_class
    Ref::WeakReference
  end
end
