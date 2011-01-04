require 'test/unit'
require File.expand_path("../../lib/references", __FILE__)
require File.expand_path("../reference_value_map_behavior", __FILE__)

class TestWeakValueMap < Test::Unit::TestCase
  include ReferenceValueMapBehavior
  
  def map_class
    References::WeakValueMap
  end
  
  def reference_class
    References::WeakReference
  end
end
