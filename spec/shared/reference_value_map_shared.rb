require 'spec_helper'

shared_examples 'a reference value map' do
  let(:value_1)  { 'value 1' }
  let(:value_2)  { 'value 2' }
  let(:value_3)  { 'value 3' }
  let(:hash)     { map_class.new }

  describe 'keeps entries with strong references' do
    specify do
      Ref::Mock.use do
        hash['key 1'] = value_1
        hash['key 2'] = value_2
        expect(hash['key 1'] ).to eq(value_1)
        expect(hash['key 2'] ).to eq(value_2)
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
      Ref::Mock.use do
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        Ref::Mock.gc(value_2)
        expect(hash.delete("key 2")).to be_nil
        expect(hash.delete("key 1")).to eq value_1
        expect(hash["key 1"]).to be_nil
      end
    end
  end

  describe 'can merge in another hash' do
    specify do
      Ref::Mock.use do
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        hash.merge!("key 3" => value_3)

        expect('value 2').to eq hash['key 2']
        expect(hash['key 1']).to eq value_1

        Ref::Mock.gc(value_2)

        expect(hash['key 2']).to be_nil
        expect(hash['key 1']).to eq value_1
        expect(hash['key 3']).to eq value_3
      end
    end
  end

  describe 'can get all values' do
    specify do
      Ref::Mock.use do
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        hash["key 3"] = value_3
        expect(["value 1", "value 2", "value 3"].sort).to eq hash.values.sort
        Ref::Mock.gc(value_2)
        expect(["value 1", "value 3"].sort).to eq hash.values.sort
      end
    end
  end

  describe 'can turn into an array' do
    specify do
      Ref::Mock.use do
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        hash["key 3"] = value_3
        order = lambda{|a,b| a.first <=> b.first}
        expect([["key 1", "value 1"], ["key 2", "value 2"], ["key 3", "value 3"]].sort(&order)).to eq hash.to_a.sort(&order)
        Ref::Mock.gc(value_2)
        expect([["key 1", "value 1"], ["key 3", "value 3"]].sort(&order)).to eq hash.to_a.sort(&order)
      end
    end
  end

  describe 'can interate over all entries' do
    specify do
      Ref::Mock.use do
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        hash["key 3"] = value_3
        keys = []
        values = []
        hash.each{|k,v| keys << k; values << v}
        expect(["key 1", "key 2", "key 3"]).to eq keys.sort
        expect(["value 1", "value 2", "value 3"]).to eq values.sort
        Ref::Mock.gc(value_2)
        keys = []
        values = []
        hash.each{|k,v| keys << k; values << v}
        expect(["key 1", "key 3"]).to eq keys.sort
        expect(["value 1", "value 3"]).to eq values.sort
      end
    end
  end

  describe 'size' do
    specify do
      Ref::Mock.use do
        hash = map_class.new
        expect(hash.empty?).to eq true
        expect(hash.size).to eq 0
        value_1 = "value 1"
        value_2 = "value 2"
        hash["key 1"] = value_1
        hash["key 2"] = value_2
        expect(hash.size).to eq 2
        Ref::Mock.gc(value_2)
        expect(hash.empty?).to eq false
        expect(hash.size).to eq 1
      end
    end
  end

  describe 'inspect' do
    specify do
      Ref::Mock.use do
        hash["key 1"] = "value 1"
        expect(hash.inspect).to_not be_nil
      end
    end
  end
end
