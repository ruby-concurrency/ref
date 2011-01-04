require 'test/unit'
require File.expand_path("../../lib/references", __FILE__)
require File.expand_path("../reference_key_map_behavior", __FILE__)

class TestSoftKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    References::SoftKeyMap
  end
  
  def reference_class
    References::SoftReference
  end
end
