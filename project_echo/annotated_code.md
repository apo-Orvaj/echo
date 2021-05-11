## Annotated Code & Examples:

<details>
  <summary>Get Authentication Token</summary>
  <markdown>
#### Request

    POST /authentication_token HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "Authentication": "eyJhbGciOiJIUzI1NiJ9.eyJBdXRoZW50aWNhdGlvbiI6IjA5ZjVkYWMwLTU2YzAtNDE1Mi04YTZiLWEyZTRlYzY5ODk2MSIsImV4cCI6MTYyMDg1ODQxN30.UcozG3VXaLppP4QtaDa5FfwbFOwnZTebpJ8Ln642Mr4"
    }
  </markdown>
</details>

<details>
  <summary>List endpoints</summary>
  <markdown>
  #### Request

    GET /endpoints HTTP/1.1
    Accept: application/vnd.api+json

  #### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [
        {
          "id": "0aef3350-445a-467d-8e52-b4673f6d00fd",
          "type": "endpoints",
          "attributes": {
            "verb": "GET",
            "path": "/zoo",
            "response": {
                "code": 200,
                "headers": {},
                "body": "{ \"message\": \"Hello, world\" }"
            }
          }
        }
      ]
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint - Success Example</summary>
  <markdown>
#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
      "data": {
        "type": "endpoints",
        "attributes": {
          "verb": "GET",
          "path": "/zoo",
          "response": {
            "code": 200,
            "headers": {},
            "body": "{ \"message\": \"Hello, world\" }"
          }
        }
      }
    }

#### Expected response

    HTTP/1.1 201 Created
    Location: http://localhost:3000/zoo
    Content-Type: application/vnd.api+json

    {
      "data": {
        "id": "09397283-4af1-4055-a676-6f65e46721d5",
        "type": "endpoints",
        "attributes": {
          "verb": "GET",
          "path": "/zoo",
          "response": {
              "code": 200,
              "headers": {},
              "body": "{ \"message\": \"Hello, world\" }"
          }
        }
      }
    }
  </markdown>
</details>

<details>
  <summary>Create endpoint - Error Example</summary>
  <markdown>
#### Request

    POST /endpoints HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
      "data": {
        "type": "endpoints",
        "attributes": {
          "verb": "ZOO",
          "path": "/zoo",
          "response": {
            "code": 200,
            "headers": {},
            "body": "{ \"message\": \"Hello, world\" }"
          }
        }
      }
    }

#### Expected response

    HTTP/1.1 201 Created
    Location: http://localhost:3000/zoo
    Content-Type: application/vnd.api+json

    {
    "errors": [
        {
            "status": 422,
            "message": [
                "Verb is not included in the list"
            ]
        }
    ]
}
  </markdown>
</details>

<details>
  <summary>Update endpoint - Success Example</summary>
  <markdown>
#### Request

    PATCH /endpoints/09397283-4af1-4055-a676-6f65e46721d5 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/zoo",
                "response": {
                  "code": 400,
                  "headers": {},
                  "body": "{ \"message\": \"Hello, world\" }"
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 200 OK
    Location: http://localhost:3000/zoo
    Content-Type: application/vnd.api+json

    {
      "data": {
          "id": "09397283-4af1-4055-a676-6f65e46721d5",
          "type": "endpoints",
          "attributes": {
              "verb": "GET",
              "path": "/zoo",
              "response": {
                  "code": 400,
                  "headers": {},
                  "body": "{ \"message\": \"Hello, world\" }"
              }
          }
      }
  }
  </markdown>
</details>

<details>
  <summary>Update endpoint - Error Example</summary>
  <markdown>
#### Request

    PATCH /endpoints/09397283-4af1-4055-a676-6f65e4672 HTTP/1.1
    Content-Type: application/vnd.api+json
    Accept: application/vnd.api+json

    {
        "data": {
            "type": "endpoints",
            "attributes": {
                "verb": "GET",
                "path": "/zoo",
                "response": {
                  "code": 400,
                  "headers": {},
                  "body": "{ \"message\": \"Hello, world\" }"
                }
            }
        }
    }

#### Expected response

    HTTP/1.1 404 Not Found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested Endpoint with ID `09397283-4af1-4055-a676-6f65e4672` does not exist"
            }
        ]
    }
  </markdown>
</details>

<details>
  <summary>Delete endpoint</summary>
  <markdown>
#### Request

    DELETE /endpoints/09397283-4af1-4055-a676-6f65e46721d5 HTTP/1.1
    Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 204 No Content
  </markdown>
</details>

<details>
  <summary>Client requests existing path</summary>
  <markdown>
#### Request

    > GET /zoo HTTP/1.1
    > Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "message": "Hello, world"
    }
  </markdown>
</details>

<details>
  <summary>Client requests non-existing path</summary>
  <markdown>
#### Request

    > GET /zoom HTTP/1.1
    > Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
      "errors": [
          {
              "code": "not_found",
              "detail": "Requested page `/zoom` does not exist"
          }
      ]
    }
  </markdown>
</details>

<details>
  <summary>Client requests the endpoint on the same path, but with different HTTP verb</summary>
  <markdown>
#### Request

    > DELETE /zoo HTTP/1.1
    > Accept: application/vnd.api+json

#### Expected response

    HTTP/1.1 404 Not found
    Content-Type: application/vnd.api+json

    {
        "errors": [
            {
                "code": "not_found",
                "detail": "Requested page `/zoo` does not exist"
            }
        ]
    }
  </markdown>
</details>
