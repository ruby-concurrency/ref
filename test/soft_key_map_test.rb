require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'references')

class TestSoftKeyMap < Test::Unit::TestCase
  def test_uses_weak_references
    assert_equal References::SoftReference, References::SoftKeyMap.reference_class
  end
end
