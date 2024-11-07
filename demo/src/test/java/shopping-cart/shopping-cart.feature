Feature: View Shopping Cart Items

Background:
Given url baseUrl
Given header Client-Id = clientId

Scenario: Successfully return the shopping cart items
    Given path '/shoppingcart/items'
    And param Type = 'Fresh'
    And param Discount = 'Applied'
    When method GET
    Then status 200
    And match response == 
    """
    {
    "basket": [
            {
                "name": "Milk",
                "quantity": "2",
                "price": "$4"
            },
            {
                "name": "Bread",
                "quantity": "1",
                "price": "$5"
            },
            {
                "name": "Eggs",
                "quantity": "1",
                "price": "$6.5"
            }
    ]
    }
    """

Scenario: Missing or invalid Client-Id
    Given path '/shoppingcart/items'
    And header Client-Id = 'invalid_headers'
    And param Type = 'Fresh'
    And param Discount = 'Applied'
    When method GET
    Then status 401
    And match response == 
    """
    { 
        "message": "Unauthorized request! Client-Id is missing or invalid."
    }
    """

Scenario: Missing or invalid parameters
    Given path '/shoppingcart/items'
    And param Discount = 'NotApplied'
    When method GET
    Then status 400
    And match response == 
    """
    { 
        "message": "Invalid request! Parameters are missing or invalid."
    }
    """

Scenario: Internal server error
    Given path '/'
    When method GET
    Then status 502
    And match response contains "Hoverfly Error!"
