require_relative 'test_helper'

class TestSoftValueMap < Test::Unit::TestCase
  include ReferenceValueMapBehavior
  
  def map_class
    Ref::SoftValueMap
  end
  
  def reference_class
    Ref::SoftReference
  end
end
