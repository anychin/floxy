FactoryGirl.define do
  factory :organization do
    sequence(:title){ |i| "title_#{i}" }
    sequence(:full_title){ |i| "Full Title #{i}" }

    factory :sample_organization do
      title 'Test Organization'
      full_title 'Full Test Organization'
    end
  end
end
