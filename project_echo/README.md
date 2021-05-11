# README

* Ruby version - 2.7.3

* Rails version - 5.2.6

## Steps to setup:

1. Clone the repository to a local directory.

2. Execute the following commands:

- bundle install
- rails db:setup
- rails s

## Steps to test:
- bundle exec rspec

## Swagger docs
To view Swagger docs for all APIs, hit: `http://localhost:3000/api-docs/index.html`.

## Features
- JWT Authentication: The CRUD APIs of endpoints on the is only accessible with JWT authentication token. However, the mock endpoints can be directly accessed, without the authentication token.
- Swagger API Documentation: All the APIs on the *Echo* or *server* is documented with Swagger.
- ActiveModelSerializers: For managing JSON responses for the APIs, with adapter: `json_api`.
- ActiveInteraction: For Service classes to manage logic or ActiveRecord transactions.
- ActiveRecordJsonValidator: To validate the incoming requests as might contain invalid data.
- RSpec: For unit testing of all controllers, models, interactions and requests.

## Gems used:
```
# To validate the json
gem 'activerecord_json_validator'

 # For json responses
gem 'active_model_serializers'

# service object with verb
gem 'active_interaction'

# Use Json Web Token (JWT) for token based authentication
gem 'jwt'

# For API documentation
gem 'rswag-api'
gem 'rswag-ui'
```

## Client Endpoints:
1. __GET {{domain}}/endpoints__  
To return a list of all existing mock endpoints.

2. __POST {{domain}}/endpoints__
To create a mock endpoint according to data from the payload, with validation of format for received data.

3. __PATCH {{domain}}/endpoints{/:id}__
To update the existing mock endpoint according to data from the payload. Also, NOT accepting invalid data or update non-existing mock endpoints.

4. __DELETE {{domain}}/endpoints{/:id}__
To delete the requested mock endpoint.

5. __{{VERB}} {{domain}}/*path__
To make mock endpoints be available over HTTP. All mock endpoints are available as they defined, with their response code, body and headers.

Annotated code and examples for all endpoints/APIs are listed on `annotated_code.md`.
