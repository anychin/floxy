FactoryGirl.define do
  factory :task do
    sequence(:title){ |i| "Task-#{i}" }
    sequence(:aim){ |i| "aim-#{i}" }
    planned_time 4
    task_level
    milestone
    project

    factory :task_sample do
      title 'Task'
      aim 'aim'
    end
  end
end
