require 'test/unit'
require File.join(File.dirname(__FILE__), '..', 'lib', 'references')

class TestReferenceQueue < Test::Unit::TestCase
  def test_can_add_references
    queue = References::ReferenceQueue.new
    ref_1 = References::WeakReference.new(Object.new)
    ref_2 = References::WeakReference.new(Object.new)
    assert queue.empty?
    assert_equal 0, queue.size
    queue.push(ref_1)
    queue.push(ref_2)
    assert !queue.empty?
    assert_equal 2, queue.size
  end
  
  def test_can_remove_references_as_a_queue
    queue = References::ReferenceQueue.new
    ref_1 = References::WeakReference.new(Object.new)
    ref_2 = References::WeakReference.new(Object.new)
    queue.push(ref_1)
    queue.push(ref_2)
    assert_equal ref_1, queue.shift
    assert_equal ref_2, queue.shift
    assert_nil queue.shift
  end
  
  def test_can_remove_references_as_a_stack
    queue = References::ReferenceQueue.new
    ref_1 = References::WeakReference.new(Object.new)
    ref_2 = References::WeakReference.new(Object.new)
    queue.push(ref_1)
    queue.push(ref_2)
    assert_equal ref_2, queue.pop
    assert_equal ref_1, queue.pop
    assert_nil queue.pop
  end
  
  def test_references_are_added_when_the_object_has_been_collected
    References::WeakReference::TestImpl.use do
      obj = Object.new
      ref = References::WeakReference.new(obj)
      queue = References::ReferenceQueue.new
      queue.monitor(ref)
      assert_nil queue.shift
      References::WeakReference::TestImpl.gc(obj)
      # Fake out calling the finalizer on the object
      finalizer = queue.instance_variable_get(:@finalizer)
      finalizer.call(obj.object_id)
      assert_equal ref, queue.shift
    end
  end
  
  def test_references_are_added_immediately_if_the_object_has_been_collected
    References::WeakReference::TestImpl.use do
      obj = Object.new
      ref = References::WeakReference.new(obj)
      References::WeakReference::TestImpl.gc(obj)
      queue = References::ReferenceQueue.new
      queue.monitor(ref)
      assert_equal ref, queue.shift
    end
  end
end
