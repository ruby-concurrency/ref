require 'spec_helper'

describe Ref::ReferenceQueue do

  let(:queue) { Ref::ReferenceQueue.new }
  let(:obj_1) { Object.new }
  let(:obj_2) { Object.new }
  let(:ref_1) { Ref::WeakReference.new(obj_1) }
  let(:ref_2) { Ref::WeakReference.new(obj_2) }

  describe '#push' do
    context 'when the queue is empty' do
      it { expect(queue.size).to be(0) }
      it { expect(queue).to be_empty }
    end

    context 'when the queue is not empty' do
      before do
        queue.push(ref_1)
        queue.push(ref_2)
      end

      it { expect(queue.size).to be(2) }
      it { expect(queue).to_not be_empty }
    end
  end

  describe '#shift' do
    context 'when the queue is not empty' do
      before do
        queue.push(ref_1)
        queue.push(ref_2)
      end
      it { expect(queue.shift).to be(ref_1) }
    end

    context 'when the queue is empty' do
      it { expect(queue.shift).to be_nil }
    end
  end

  describe '#pop' do
    context 'when the queue is not empty' do
      before do
        queue.push(ref_1)
        queue.push(ref_2)
      end

      it { expect(queue.pop).to be(ref_2) }
    end
    context 'when the queue is empty' do
      it { expect(queue.pop).to be_nil }
    end
  end

  describe 'references are added immediately if the_object has been collected' do
    specify do
      Ref::Mock.use do
        ref = Ref::WeakReference.new(obj_1)
        Ref::Mock.gc(obj_1)
        queue.monitor(ref)

        expect(ref).to equal(queue.shift)
      end
    end
  end
end
