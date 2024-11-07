Feature: Create Token API

  Background:
    Given url baseUrl

  @create-token
  Scenario: Successfully create token
    Given path '/token'
    And request { "key": "quality-engineering" }
    And header Client-Id = 50
    When method POST
    Then status 200
    And match response == 
    """
    {
       "token": "#string"
    }
    """
    * def unique_token  = response["token"]

  Scenario: Invalid key in request
    Given path '/token'
    And request { "key": "invalid-key" }
    When method POST
    Then status 400
    And match response == 
    """
    { 
        "error": "Invalid key!"
    }
    """

  Scenario: Internal server error
    Given path '/'
    When method POST
    Then status 502
    And match response contains "Hoverfly Error!"
