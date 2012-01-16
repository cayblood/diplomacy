Feature: Move rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Simple move
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
    Austria: A Vie-Bud
    """
    Then the order resolution report should be:
    """
    Austria: A Vie-Bud
    """
    And there should be the following units:
    """
    Austria: A Bud
    """

  Scenario: Invalid move due to invalid destination
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
    Austria: A Vie-Tri
    """
    Then the order resolution report should be:
    """
    Austria: _A_Vie-Tri_
    """
    And there should be the following units:
    """
    Austria: A Vie
    """