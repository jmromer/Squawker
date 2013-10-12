FactoryGirl.define do
  factory :user do
    name      "Michael Johnson"
    email     "michael@running.com"
    password  "foobar"
    password_confirmation "foobar"
  end
end