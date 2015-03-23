require 'spec_helper'

describe Ref::Mock do

  context 'gc with argument' do
    specify do
      Ref::Mock.use do
        obj_1 = Object.new
        obj_2 = Object.new

        ref_1 = Ref::WeakReference.new(obj_1)
        ref_2 = Ref::WeakReference.new(obj_2)

        Ref::Mock.gc(obj_1)

        expect(ref_1.object).to be_nil
        expect(ref_2.object).to equal(obj_2)
      end
    end
  end

  context 'gc with no argument' do
    specify do
      Ref::Mock.use do
        obj_1 = Object.new
        obj_2 = Object.new

        ref_1 = Ref::WeakReference.new(obj_1)
        ref_2 = Ref::WeakReference.new(obj_2)

        Ref::Mock.gc

        expect(ref_1.object).to be_nil
        expect(ref_2.object).to be_nil
      end
    end
  end

end
