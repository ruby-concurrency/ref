require 'test/unit'
require File.expand_path("../../lib/ref", __FILE__)
require File.expand_path("../reference_key_map_behavior", __FILE__)

class TestWeakKeyMap < Test::Unit::TestCase
  include ReferenceKeyMapBehavior
  
  def map_class
    Ref::WeakKeyMap
  end
  
  def reference_class
    Ref::WeakReference
  end
end
