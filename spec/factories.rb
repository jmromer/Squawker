# frozen_string_literal: true

FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "password"
    password_confirmation "password"

    factory :admin do
      admin true
    end
  end

  factory :squawk do
    content "Lorem ipsum"
    user
  end

  factory :like do
    liker factory: :user
    liked_squawk factory: :squawk
  end

  factory :flag do
    flagger factory: :user
    flagged_squawk  factory: :squawk
  end
end
