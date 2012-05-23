Feature: Support rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Simple support
    Given the following board:
      | full name  | province | type    | neighbors |
      | Marseilles | Mar      | coastal | Bur,Gas   |
      | Gascony    | Gas      | coastal | Mar,Bur   |
      | Burgundy   | Bur      | inland  | Gas,Mar   |
    And there are the following units:
    """
    France: A Mar, A Gas
    Germany: A Bur
    """
    When the following orders are resolved:
    """
    France: A Mar-Bur, A Gas S A Mar-Bur
    Germany: A Bur-Holds
    """
    Then the order resolution report should be:
    """
    France: A Mar-Bur, A Gas S A Mar-Bur
    Germany: _A_Bur-Holds_
    """
    And there should be the following units:
    """
    France: A Bur, A Gas
    Germany: A dislodged from Bur
    """