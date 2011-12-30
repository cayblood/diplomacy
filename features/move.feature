Feature: Movement rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Simple hold in one province world
    Given the following board:
      | full name | province | type   | neighbors |
      | Vienna    | Vie      | inland |           |
    And there are the following units:
    """
    Austria: A Vie
    """
    When the following orders are resolved:
    """
    Austria: A Vie Holds
    """
    Then the order resolution report should be:
    """
    Austria: A Vie Holds
    """
    And there should be the following units:
    """
    Austria: A Vie
    """

  Scenario: Invalid hold in two province world
    Given the following board:
      | full name | province | type   | neighbors |
      | Vienna    | Vie      | inland | Bud       |
      | Budapest  | Bud      | inland | Vie       |
    And there are the following units:
    """
    Austria: A Vie
    """
    When the following orders are resolved:
    """
    Austria: A Bud Holds
    """
    Then the order resolution report should be:
    """
    Austria: _A_Bud_Holds_
    """
    And there should be the following units:
    """
    Austria: A Vie
    """
