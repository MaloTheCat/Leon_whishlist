FactoryBot.define do
  factory :gift do
    name { "MyString" }
    price { "9.99" }
    link { "MyString" }
    image { "MyString" }
    user { nil }
    reserved_by { nil }
  end
end
