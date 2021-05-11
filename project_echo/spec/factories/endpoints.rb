FactoryBot.define do
  factory :endpoint do
    verb { "GET" }
    path { "/foo" }
    response { {code: 200, headers: {}, body: JSON.generate({ message: 'Hello world' })} }
  end
end
