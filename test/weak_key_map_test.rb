require 'test/unit'
require File.expand_path("../../lib/references", __FILE__)
require File.expand_path("../reference_key_map_behavior", __FILE__)

class TestWeakKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    References::WeakKeyMap
  end
  
  def reference_class
    References::WeakReference
  end
end
