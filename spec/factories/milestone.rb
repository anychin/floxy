FactoryGirl.define do
  factory :milestone do
    sequence(:title){ |i| "Milestone title_#{i}" }
    sequence(:aim){ |i| "Milestone aim_#{i}" }
    project
    organization

    factory :sample_milestone do
      title 'Milestone'
      aim 'Milestone-aim'
    end
  end
end
