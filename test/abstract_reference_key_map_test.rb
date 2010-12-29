require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'references')

class TestAbstractReferenceKeyMap < Test::Unit::TestCase
  def setup
    # Use an implementation of WeakReference that is meant for testing since it allows
    # for simulating garbage collection.
    @weak_reference_implementation = References::WeakReference.implementation
    References::WeakReference.implementation = References::WeakReference::TestImpl
  end

  def teardown
    References::WeakReference.implementation = @weak_reference_implementation
    References::WeakReference::TestImpl.gc
  end

  def test_keeps_entries_with_strong_references
    hash = References::WeakKeyMap.new
    key_1 = Object.new
    key_2 = Object.new
    hash[key_1] = "value 1"
    hash[key_2] = "value 2"
    assert_equal "value 1", hash[key_1]
    assert_equal "value 2", hash[key_2]
  end

  def test_removes_entries_that_have_been_garbage_collected
    hash = References::WeakKeyMap.new
    key_1 = Object.new
    key_2 = Object.new
    hash[key_1] = "value 1"
    hash[key_2] = "value 2"
    assert_equal "value 1", hash[key_1]
    assert_equal "value 2", hash[key_2]
    References::WeakReference::TestImpl.gc(key_2)
    assert_equal "value 1", hash[key_1]
    assert_nil hash[key_2]
  end

  def test_can_clear_the_map
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    key_1 = Object.new
    key_2 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    hash.clear
    assert_nil hash[key_1]
    assert_nil hash[key_2]
  end

  def test_can_delete_entries
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    key_1 = Object.new
    key_2 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    References::WeakReference::TestImpl.gc(key_2)
    assert_nil hash.delete(key_2)
    assert_equal value_1, hash.delete(key_1)
    assert_nil hash[key_1]
  end

  def test_can_merge_in_another_hash
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    value_3 = "value 3"
    key_1 = Object.new
    key_2 = Object.new
    key_3 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    hash.merge!(key_3 => value_3)
    assert_equal "value 2", hash[key_2]
    assert_equal value_1, hash[key_1]
    References::WeakReference::TestImpl.gc(key_2)
    assert_nil hash[key_2]
    assert_equal value_1, hash[key_1]
    assert_equal value_3, hash[key_3]
  end

  def test_can_get_all_keys
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    value_3 = "value 3"
    key_1 = Object.new
    key_2 = Object.new
    key_3 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    hash[key_3] = value_3
    assert_equal [], [key_1, key_2, key_3] - hash.keys
    References::WeakReference::TestImpl.gc(key_2)
    assert_equal [key_2], [key_1, key_2, key_3] - hash.keys
  end

  def test_can_turn_into_an_array
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    value_3 = "value 3"
    key_1 = Object.new
    key_2 = Object.new
    key_3 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    hash[key_3] = value_3
    order = lambda{|a,b| a.last <=> b.last}
    assert_equal [[key_1, "value 1"], [key_2, "value 2"], [key_3, "value 3"]].sort(&order), hash.to_a.sort(&order)
    References::WeakReference::TestImpl.gc(key_2)
    assert_equal [[key_1, "value 1"], [key_3, "value 3"]].sort(&order), hash.to_a.sort(&order)
  end

  def test_can_iterate_over_all_entries
    hash = References::WeakKeyMap.new
    value_1 = "value 1"
    value_2 = "value 2"
    value_3 = "value 3"
    key_1 = Object.new
    key_2 = Object.new
    key_3 = Object.new
    hash[key_1] = value_1
    hash[key_2] = value_2
    hash[key_3] = value_3
    keys = []
    values = []
    hash.each{|k,v| keys << k; values << v}
    assert_equal [], [key_1, key_2, key_3] - keys
    assert_equal ["value 1", "value 2", "value 3"], values.sort
    References::WeakReference::TestImpl.gc(key_2)
    keys = []
    values = []
    hash.each{|k,v| keys << k; values << v}
    assert_equal [key_2], [key_1, key_2, key_3] - keys
    assert_equal ["value 1", "value 3"], values.sort
  end

  def test_inspect
    hash = References::WeakKeyMap.new
    hash[Object.new] = "value 1"
    assert hash.inspect
  end
end
