FactoryGirl.define do
  factory :project do
    sequence(:title){ |i| "Project title_#{i}" }
    organization
    team

    factory :sample_project do
      title "Project"
    end
  end
end
