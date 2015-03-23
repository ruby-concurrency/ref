require 'spec_helper'

describe Ref::SoftKeyMap do
  it_behaves_like 'a reference key map' do
    let(:map_class)  { Ref::SoftKeyMap }
    let(:reference_class) { Ref::SoftReference }
  end
end
