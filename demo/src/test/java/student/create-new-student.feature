Feature: Create New Student 

Background: 
    Given url baseUrl
    * def auth = callonce read("classpath:student/create-token.feature@create-token")
    * def create_token = auth.unique_token

    And header Client-Id = clientId
    And header Authorization = create_token

Scenario: Successfully create student
    Given path '/student/create'
    And request
    """
    {
      "firstName": "John",
      "lastName": "Doe",
      "nationality": "American",
      "dateOfBirth": "01/01/1990",
      "email": "john.doe276372@example.com",
      "mobileNumber": "1234567890"
    }
    """
    When method POST
    Then status 201
    And match response.id != null
    And match response == 
    """
    { 
        "message": "New student was created successfully!"
    }
    """

Scenario: Client-Id missing 
    Given path '/student/create'
    And header Client-Id = 'invalid_headers'
    And request
    """
    {
      "firstName": "John",
      "lastName": "Doe",
      "nationality": "American",
      "dateOfBirth": "01/01/1990",
      "email": "john.doe276372@example.com",
      "mobileNumber": "1234567890"
    }
    """
    When method POST
    Then status 401
    And match response == 
    """
    { 
        "message": "Unauthorized request." 
    }
    """

Scenario: Authorization missing or invalid 
    Given path '/student/create'
    And header Authorization = 'invalid_token'
    And request
    """
    {
      "firstName": "John",
      "lastName": "Doe",
      "nationality": "American",
      "dateOfBirth": "01/01/1990",
      "email": "john.doe276372@example.com",
      "mobileNumber": "1234567890"
    }
    """
    When method POST
    Then status 401
    And match response == 
    """
    { 
        "message": "Unauthorized request." 
    }
    """

Scenario: Student exists
    Given path '/student/create'
    And request
    """
    {
      "firstName": "Jane",
      "lastName": "Doe",
      "nationality": "American",
      "dateOfBirth": "01/01/1990",
      "email": "hibgasdguiad@email.com",
      "mobileNumber": "1234567890"
    }
    """
    When method POST
    Then status 400
    And match response == 
    """
    { 
        "message": "ERROR! Student exists!" 
    }
    """

Scenario: Other cases
    Given path '/'
    When method POST
    Then status 502
    And match response contains "Hoverfly Error!"
