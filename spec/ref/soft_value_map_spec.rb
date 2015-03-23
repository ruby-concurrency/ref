require 'spec_helper'

describe Ref::SoftValueMap do
  it_behaves_like 'a reference value map' do
    let(:map_class)  { Ref::SoftValueMap }
    let(:reference_class) { Ref::SoftReference }
  end
end
