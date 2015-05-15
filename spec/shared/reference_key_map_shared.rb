require 'spec_helper'

shared_examples 'a reference key map' do
  let(:value_1)  { 'value 1' }
  let(:value_2)  { 'value 2' }
  let(:value_3)  { 'value 3' }
  let(:key_1)    { Object.new }
  let(:key_2)    { Object.new }
  let(:key_3)    { Object.new }
  let(:hash)     { map_class.new }

  context 'keeps entries with strong references' do
    specify do
      Ref::Mock.use do
        hash[key_1] = "value 1"
        hash[key_2] = "value 2"
        expect(hash[key_1]).to eq "value 1"
        expect(hash[key_2]).to eq "value 2"
      end
    end
  end

  context 'removes entries that have been garbage collected' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        expect(hash[key_1]).to eq(value_1)
        expect(hash[key_2]).to eq(value_2)
        Ref::Mock.gc(key_2)
        expect(hash[key_1]).to eq(value_1)
        expect(hash[key_2]).to be_nil
      end
    end
  end

  context 'can clear the map' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash.clear
        expect(hash[key_1]).to be_nil
        expect(hash[key_2]).to be_nil
      end
    end
  end

  context 'can delete entries' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        Ref::Mock.gc(key_2)
        expect(hash.delete(key_2)).to be_nil
        expect(hash.delete(key_1)).to eq(value_1)
        expect(hash[key_1]).to be_nil
      end
    end
  end

  context 'can merge in another hash' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash.merge!(key_3 => value_3)

        expect(hash[key_2]).to eq 'value 2'
        expect(hash[key_1]).to eq value_1

        Ref::Mock.gc(key_2)

        expect(hash[key_2]).to be_nil
        expect(hash[key_1]).to eq value_1
        expect(hash[key_3]).to eq value_3
      end
    end
  end

  context 'can get all keys' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash[key_3] = value_3
        expect([key_1, key_2, key_3] - hash.keys).to eq []
        Ref::Mock.gc(key_2)
        expect([key_1, key_2, key_3] - hash.keys).to eq [key_2]
      end
    end
  end

  context 'can turn into an array' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash[key_3] = value_3
        order = lambda{|a,b| a.last <=> b.last}
        expect([[key_1, "value 1"], [key_2, "value 2"], [key_3, "value 3"]].sort(&order)).to eq hash.to_a.sort(&order)
        Ref::Mock.gc(key_2)
        expect([[key_1, "value 1"], [key_3, "value 3"]].sort(&order)).to eq hash.to_a.sort(&order)
      end
    end
  end

  context 'can turn into a hash' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash[key_3] = value_3
        order = lambda{|a,b| a.last <=> b.last}
        expect({key_1 => "value 1", key_2 => "value 2", key_3 => "value 3"}.sort(&order)).to eq hash.to_h.sort(&order)
        Ref::Mock.gc(key_2)
        expect({key_1 => "value 1", key_3 => "value 3"}.sort(&order)).to eq hash.to_h.sort(&order)
      end
    end
  end

  context 'can interate over all entries' do
    specify do
      Ref::Mock.use do
        hash[key_1] = value_1
        hash[key_2] = value_2
        hash[key_3] = value_3
        keys = []
        values = []
        hash.each{|k,v| keys << k; values << v}
        expect([key_1, key_2, key_3] - keys).to eq []
        expect(["value 1", "value 2", "value 3"]).to eq values.sort
        Ref::Mock.gc(key_2)
        keys = []
        values = []
        hash.each{|k,v| keys << k; values << v}
        expect([key_1, key_2, key_3] - keys).to eq [key_2]
        expect(["value 1", "value 3"]).to eq values.sort
      end
    end
  end

  context 'size' do
    specify do
      Ref::Mock.use do
        hash = map_class.new
        expect(hash.empty?).to eq true
        expect(hash.size).to eq 0
        key_1 = Object.new
        key_2 = Object.new
        hash[key_1] = "value 1"
        hash[key_2] = "value 2"
        expect(hash.size).to eq 2
        Ref::Mock.gc(key_2)
        expect(hash.empty?).to eq false
        expect(hash.size).to eq 1
      end
    end
  end

  context 'inspect' do
    specify do
      Ref::Mock.use do
        hash[Object.new] = "value 1"
        expect(hash.inspect).to_not be_nil
      end
    end
  end

  context '#merge' do

    let(:new_value){ Object.new }
    let(:values){ {key_1 => value_1, key_2 => value_2, key_3 => value_3} }
    let(:this) do
      values.each{|k, v| hash[k] = v }
      hash
    end
    let(:other){ {key_3 => new_value} }

    it 'updates all members with the new values from a given hash' do
      expect(this.merge(other)[key_3]).to eq new_value
    end

    it 'calls the given block for each key in `other`' do
      actual = 0
      this.merge(key_2 => 'yes', key_3 => 'no'){|member, thisval, otherval| actual += 1; Object.new }
      expect(actual).to eq 2
    end

    it 'retains the value for all members without values in the given hash' do
      expect(this.merge(other)[key_1]).to eq value_1
    end

    it 'adds members not in the original hash' do
      new_key = Object.new
      new_value = 'life, the universe, and everything'
      expect(this.merge(new_key => new_value)[new_key]).to eq new_value
    end

    it 'returns a deep copy when merging an empty hash' do
      other = this.merge({})
      values.each do |key, value|
        expect(other[key]).to eq value
      end
    end

    it 'returns a new object' do
      expect(this.merge(other).object_id).to_not eq this.object_id
      expect(this.merge(other).object_id).to_not eq other.object_id
    end
  end
end
