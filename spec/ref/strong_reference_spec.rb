require 'spec_helper'

describe Ref::StrongReference do
  let(:obj) { Object.new }
  let(:ref) { Ref::StrongReference.new(obj) }

  context '#object' do
    it { expect(obj).to equal(ref.object) }
    it { expect(obj.object_id).to equal(ref.referenced_object_id) }
  end

  context '#inspect' do
    it { expect(ref.inspect).to_not be_empty }
  end
end
