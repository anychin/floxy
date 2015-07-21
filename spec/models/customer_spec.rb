require 'rails_helper'

RSpec.describe Customer, :type => :model do
  it { should respond_to(:name_id) }

  describe "name_id validations" do
    let(:customer) { FactoryGirl.create(:customer) }

    it 'presence' do
      customer = Customer.new(name_id: '')
      expect(customer.save).to eq false
    end

    it 'should not be empty' do
      customer = Customer.new(name_id: ' ')
      expect(customer.save).to eq false
    end

    it 'should not be special characters' do
      customer = Customer.new(name_id: 'jks;;;')
      expect(customer.save).to eq false
    end

    it 'should not be less then 4 and greater then 9' do
      customer = Customer.new(name_id: 'abc')
      expect(customer.save).to eq false

      customer = Customer.new(name_id: 'abcdefghijklmn')
      expect(customer.save).to eq false
    end

    it 'should have length 4..9 symbols' do
      customer = Customer.new(name_id: 'abcd')
      expect(customer.save).to eq true
    end

    it 'can include _' do
      customer = Customer.new(name_id: 'abcd_e')
      expect(customer.save).to eq true
    end

    it 'can include numbers' do
      customer = Customer.new(name_id: 'abcd_5')
      expect(customer.save).to eq true
    end

    it 'can include uppercase' do
      customer = Customer.new(name_id: 'IVANOV_AV')
      expect(customer.save).to eq true
    end
  end
end
