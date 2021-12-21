FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      username { Faker::Internet.username }
      password { Faker::Internet.password }

      trait :confirmed do
        confirmed_at { Time.zone.now }
        confirmation_sent_at { Time.zone.now }
        
      end
    end    
  end