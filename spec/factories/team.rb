FactoryGirl.define do
  factory :team do
    sequence(:title){ |i| "Team title_#{i}" }
    organization

    factory :sample_team do
      title "Team"
    end
  end
end
