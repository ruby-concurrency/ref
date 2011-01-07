require 'test/unit'
require File.expand_path("../../lib/ref", __FILE__)
require File.expand_path("../reference_key_map_behavior", __FILE__)

class TestSoftKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    Ref::SoftKeyMap
  end
  
  def reference_class
    Ref::SoftReference
  end
end
