require 'spec_helper'

shared_examples 'a reference key map' do

  let(:value_1)  { 'value 1' }
  let(:value_2)  { 'value 2' }
  let(:value_3)  { 'value 3' }
  let(:key_1)    { Object.new }
  let(:key_2)    { Object.new }
  let(:hash)     { map_class.new }

  describe 'keeps entries with strong references' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        expect(hash[key_1] ).to eq(value_1)
        expect(hash[key_2] ).to eq(value_2)
      end
    end
  end

  describe 'removes entries that have been garbage collected' do
    specify do
      Ref::Mock.use do
        hash['key 1'] = value_1
        hash['key 2'] = value_2
        expect(hash['key 1']).to eq(value_1)
        expect(hash['key 2']).to eq(value_2)
        Ref::Mock.gc(value_2)
        expect(value_1).to eq(value_1)
        expect(hash['key 2']).to be_nil
      end
    end
  end

  describe 'can clear the map' do
    specify do
      hash['key 1'] = value_1
      hash['key 2'] = value_2
      hash.clear
      expect(hash['key 1']).to be_nil
      expect(hash['key 2']).to be_nil
    end
  end

  describe 'can delete entries' do
    specify do
      hash['key 1'] = value_1
      hash['key 2'] = value_2
      expect(hash.delete('key 3')).to be_nil
      expect(hash.delete('key 1')).to eq(value_1)
      expect(hash['key 1']).to be_nil
    end
  end

  describe 'can merge in another hash' do
    specify do
      hash['key 1'] = value_1
      hash['key 2'] = value_2
      hash.merge!("key 3" => value_3)
      expect(hash['key 1']).to be_nil

    end
  end
end
