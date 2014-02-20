FactoryGirl.define do
  factory :cake, class: ::Cake do
    name 'ROFL'
    deliciousness 10
    user
  end

  factory :user, class: ::User do
    username 'test'
    password 'testpassword'

    factory :user_with_cakes, class: ::User do
      ignore do
        cakes_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:cake, evaluator.cakes_count, user: user)
      end
    end
  end
end
