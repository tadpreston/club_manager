# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_subscription, :class => 'EventSubscriptions' do
    event_id 1
    user_id 1
  end
end
