FactoryGirl.define do
  factory :customer do
    sequence(:name_id){ |i| "customer_#{i}" }

    factory :sample_customer do
      name_id 'customer'
    end
  end
end
