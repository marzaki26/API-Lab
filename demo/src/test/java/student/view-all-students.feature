Feature: View All Students API

Background:
  Given url baseUrl
  * def auth = callonce read("classpath:student/create-token.feature@create-token")
  * def create_token = auth.unique_token
  And header Client-Id = clientId
  And header Authorization = create_token

Scenario: Successfully return the list of students
  Given path '/students'
  When method GET
  Then status 200
  And match response == 
  """
  [
    {
      "id": "bd8a7407-e5d2-4dfb-9bfe-69829f457698",
      "firstName": "ABC",
      "lastName": "DEF",
      "nationality": "Australian",
      "dateOfBirth": "01/01/1994",
      "email": "hibgasdguiad@email.com",
      "mobileNumber": "0111111111"
    },
    {
      "id": "c40f8e99-bde5-4af4-ba9e-de67314229fb",
      "firstName": "Name",
      "lastName": "Last Name",
      "nationality": "English",
      "dateOfBirth": "01/01/1974",
      "email": "hjbagsdjs@email.com",
      "mobileNumber": "0111111111"
    }
  ]
  """

Scenario: Missing or invalid Authorization token
  Given path '/students'
  And header Authorization = 'invalid-token'
  When method GET
  Then status 401
  And match response == 
  """
  { 
    "message": "Unauthorized request." 
  }
  """

Scenario: Internal server error
  Given path '/'
  When method GET
  Then status 502
  And match response contains "Hoverfly Error!"
