FactoryGirl.define do

  factory :user do
    email 'email@email.com'
    first_name 'aaron'
    last_name 'kendall'
    username 'Ken'
    password 'secret'
    password_confirmation 'secret'
  end
end
