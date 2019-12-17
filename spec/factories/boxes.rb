# frozen_string_literal: true

FactoryBot.define do
  factory :box do
    sequence(:name) { |n| "box #{n}" }
    notice { 'this is box for test' }

    trait :with_image do
      file = File.new(File.join('spec', 'resources', 'eggs.jpg'), 'rb')

      image { file }
    end
  end

  factory :another_box, class: 'Box' do
    name { 'another box' }
    notice { 'this is another box' }
  end

  factory :no_name_box, class: 'Box' do
    notice { 'this box has no name' }
  end
end
