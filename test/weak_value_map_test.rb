require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'references')

class TestWeakValueMap < Test::Unit::TestCase
  def test_uses_weak_references
    assert_equal References::WeakReference, References::WeakValueMap.reference_class
  end
end
