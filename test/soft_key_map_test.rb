require_relative 'test_helper'

class TestSoftKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    Ref::SoftKeyMap
  end
  
  def reference_class
    Ref::SoftReference
  end
end
