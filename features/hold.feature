Feature: Hold rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Simple hold
    Given the following board:
      | full name | province | type   | neighbors |
      | Vienna    | Vie      | inland |           |
    And there are the following units:
    """
    Austria: A Vie
    """
    When the following orders are resolved:
    """
    Austria: A Vienna Holds
    """
    Then the order resolution report should be:
    """
    Austria: A Vienna Holds
    """
    And there should be the following units:
    """
    Austria: A Vie
    """

  Scenario: Simple hold with abbreviations
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

  Scenario: Invalid hold because province doesn't contain a unit
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

  Scenario: Invalid hold because province does not exist
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
    Austria: A Tri Holds
    """
    Then the order resolution report should be:
    """
    Austria: _A_Tri_Holds_
    """
    And there should be the following units:
    """
    Austria: A Vie
    """

  Scenario: Invalid hold because of unit type mismatch
    Given the following board:
      | full name       | province | type   | neighbors |
      | Picardy         | Pic      | inland | Eng       |
      | English Channel | Eng      | inland | Pic       |
    And there are the following units:
    """
    England: F Eng
    """
    When the following orders are resolved:
    """
    England: A Eng Holds
    """
    Then the order resolution report should be:
    """
    England: _A_Eng_Holds_
    """
    And there should be the following units:
    """
    England: F Eng
    """