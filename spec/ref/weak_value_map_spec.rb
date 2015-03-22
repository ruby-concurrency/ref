require 'spec_helper'

describe Ref::WeakValueMap do
  it_behaves_like 'a reference value map' do
    let(:map_class)  { Ref::WeakValueMap }
    let(:reference_class) { Ref::WeakReference }
  end
end
