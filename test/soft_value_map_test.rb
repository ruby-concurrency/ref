require 'test/unit'
require File.expand_path("../../lib/references", __FILE__)
require File.expand_path("../reference_value_map_behavior", __FILE__)

class TestSoftValueMap < Test::Unit::TestCase
  include ReferenceValueMapBehavior
  
  def map_class
    References::SoftValueMap
  end
  
  def reference_class
    References::SoftReference
  end
end
