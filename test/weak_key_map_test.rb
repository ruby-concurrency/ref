require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'references')

class TestWeakKeyMap < Test::Unit::TestCase
  def test_uses_weak_references
    assert_equal References::WeakReference, References::WeakKeyMap.reference_class
  end
end
