require 'test/unit'
require File.expand_path("../../lib/ref", __FILE__)
require File.expand_path("../reference_value_map_behavior", __FILE__)

class TestSoftValueMap < Test::Unit::TestCase
  include ReferenceValueMapBehavior
  
  def map_class
    Ref::SoftValueMap
  end
  
  def reference_class
    Ref::SoftReference
  end
end
