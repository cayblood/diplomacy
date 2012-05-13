Feature: Standoff rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Simple standoff
    Given the following board:
      | full name | province | type    | neighbors |
      | Berlin    | Ber      | coastal | Sil       |
      | Silesia   | Sil      | inland  | Ber,War   |
      | Warsaw    | War      | inland  | Sil       |
    And there are the following units:
    """
    Germany: A Ber
    Russia: A War
    """
    When the following orders are resolved:
    """
    Germany: A Ber-Sil
    Russia: A War-Sil
    """
    Then the order resolution report should be:
    """
    Germany: _A_Ber-Sil_
    Russia: _A_War-Sil_
    """
    And there should be the following units:
    """
    Germany: A Ber
    Russia: A War
    """
