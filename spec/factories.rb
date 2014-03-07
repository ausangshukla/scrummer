include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :user do

    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password {email}
    active {true}
    confirmation_sent_at { Time.now }
    confirmed_at { Time.now }
    sign_in_count { 5 }

    trait :new_user do
      confirmed_at nil
      confirmation_sent_at nil
      sign_in_count nil
    end

    factory :scrum_master do
      role {"Scrum Master"}
    end

    factory :team_member do
      vendor_buyer_flag {"Vendor"}
      role {"Team Member"}
    end

  end

  factory :project do
    name { Faker::Company.catch_phrase }
    start_date { Date.today - rand(30).days }
    end_date { Date.today + 30.days  + rand(100).days }
    status { Project::RAG_STATUSES[rand(3)] }
  end

  factory :sprint do
    start_date { Date.today - rand(30).days }
    end_date { Date.today + 30.days  + rand(100).days }
    notes { Faker::Lorem.sentence(20) }
  end

  factory :feature do
    summary { Faker::Company.catch_phrase }
    details { Faker::Lorem.sentence(20) }
    acceptance_criteria { Faker::Lorem.sentence(20) }
    status { Feature::STATUSES[rand(3)] }
    priority { Feature::PRIORITIES[rand(Feature::PRIORITIES.length)] }
    classification { Feature::CLASSIFICATIONS[rand(Feature::CLASSIFICATIONS.length)] }
    points { 1 + rand(10) }
  end

  factory :task do
    summary { Faker::Company.catch_phrase }
    details { Faker::Lorem.sentence(20) }
    notes { Faker::Lorem.sentence(20) }
    status { Task::STATUSES[rand(Task::STATUSES.length)] }
    task_type { Task::TYPES[rand(Task::TYPES.length)] }
    planned_hours { 2 + rand(9) }
    actual_hours { 2 + rand(9) }
  end
end
