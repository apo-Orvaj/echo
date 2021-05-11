## Contents
The repository contains two folders, `back-end-challenge` and `project_echo`.
- back-end-challenge: This is the code challenge. It contains changes that were made to some of the tests and for implementing additional functionality.
- project_echo: It is *Echo* or *server*, to serve ephemeral/mock endpoints created with parameters specified by clients. The framework used for the implementation is `Rails`. The project has its own `README.md` that includes instructions on how to run and test the project on a local machine.

## Additional Features
- JWT Authentication: The CRUD APIs of endpoints on the *Echo* or *server* is only accessible with JWT authentication token.
- Swagger API Documentation: All the APIs on the *Echo* or *server* is documented with Swagger.
- ActiveModelSerializers: For managing JSON responses for the APIs, with adapter: `json_api`.
- ActiveInteraction: For Service classes to manage logic or ActiveRecord transactions.
- ActiveRecordJsonValidator: To validate the incoming requests as might contain invalid data.
- RSpec: For unit testing of all controllers, models, interactions and requests.

## Changes
Here are the changes made to the original back-end-challenge.

1. Changes to implement authorizing CRUD APIs of endpoints, using an 'Authentication' token. File: `client/lib/echo.rb`, method `initialize` to get the 'Authentication' token from the *Echo* or *server*.
```
  def initialize(server_url:)
    auth_connection = Faraday.new(url: server_url)
    auth_response = auth_connection.post('authentication_token', {})
    auth_token = JSON.parse(auth_response.body)['Authentication']
    headers = { 'Content-Type' => 'application/json', 'Authentication' => auth_token }
    @connection = Faraday.new(url: server_url, headers: headers)
  end 
```

2. File: `client/lib/echo.rb`, method `make_from_response` is changed, to fetch `id` by `data.dig(:data, :id)`.
```
  def self.make_from_response(response)
    raise(Error, 'cannot make an Endpoint from failed response') if response.failure?

    data = JSON.parse(response.body, symbolize_names: true)
    new(id: data.dig(:data, :id),
        verb: data.dig(:data, :attributes, :verb),
        path: data.dig(:data, :attributes, :path),
        response: data.dig(:data, :attributes, :response))
  end
```

3. File `client/scenario/test_list.rb`, test `test_server_to_respond_with_empty_list` is changed to `test_server_to_respond_with_correct_types` to ensure that the *Echo* or *server* returns the endpoints with correct types.
```
  def test_server_to_respond_with_correct_types
    response = api.list_endpoints

    exp = ['endpoints']
    act = JSON.parse(response.body, symbolize_names: true)[:data].map{|endpoint| endpoint[:type]}.uniq

    assert_equal(exp, act)
  end
```

4. File `client/scenario/test_update.rb`, test `test_server_to_refuse_invalid_path` is changed to use an existing endpoint, to ensure that it hits the correct endpoint, but throws back an error for invalid_path.
```
  def test_server_to_refuse_invalid_path
    %w[` > < |].each do |char|
      @payload[:path] = char
      response = api.update_endpoint(@endpoint.id, **@payload)

      exp = 422
      act = response.status_code

      assert_equal(exp, act)
    end
  end
```

5. File `client/scenario/test_update.rb`, test `test_server_to_refuse_to_update_non_existing_endpoint` is changed to use a non-existing endpoint, with `id: SecureRandom.hex`.
```
  def test_server_to_refuse_to_update_non_existing_endpoint
    response = api.update_endpoint(SecureRandom.hex, **@payload)

    exp = 404
    act = response.status_code

    assert_equal(exp, act)
  end
```

6. Similarly, File `client/scenario/test_delete.rb`, test `test_server_to_refuse_to_delete_non_existing_endpoint` is changed to use a non-existing endpoint, with `id: SecureRandom.hex`.
```
  def test_server_to_refuse_to_delete_non_existing_endpoint
    response = api.delete_endpoint(SecureRandom.hex)

    exp = 404
    act = response.status_code

    assert_equal(exp, act)
  end
```
