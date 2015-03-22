require 'spec_helper'

describe Ref::WeakKeyMap do
  it_behaves_like 'a reference key map' do
    let(:map_class)  { Ref::WeakKeyMap }
    let(:reference_class) { Ref::WeakReference }
  end
end
