Feature: Standoff rules
  As a diplomacy enthusiast
  I want a computer program to handle all the orders and the board state
  In order to be able play diplomacy more often and learn cucumber

  Scenario: Standoff when two units try to move to same destination
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

  Scenario: Standoff when two units try to move to a destination with a holding unit
    Given the following board:
      | full name | province | type    | neighbors |
      | Berlin    | Ber      | coastal | Sil       |
      | Silesia   | Sil      | inland  | Ber,War   |
      | Warsaw    | War      | inland  | Sil       |
    And there are the following units:
    """
    Germany: A Ber
    Austria: A Sil
    Russia: A War
    """
    When the following orders are resolved:
    """
    Germany: A Ber-Sil
    Austria: A Sil-Holds
    Russia: A War-Sil
    """
    Then the order resolution report should be:
    """
    Germany: _A_Ber-Sil_
    Austria: A Sil-Holds
    Russia: _A_War-Sil_
    """
    And there should be the following units:
    """
    Germany: A Ber
    Austria: A Sil
    Russia: A War
    """

  Scenario: Standoff when one unit tries to move to a destination with a holding unit
    Given the following board:
      | full name | province | type    | neighbors |
      | Berlin    | Ber      | coastal | Sil       |
      | Silesia   | Sil      | inland  | Ber,War   |
    And there are the following units:
    """
    Germany: A Ber
    Austria: A Sil
    """
    When the following orders are resolved:
    """
    Germany: A Ber-Sil
    Austria: A Sil-Holds
    """
    Then the order resolution report should be:
    """
    Germany: _A_Ber-Sil_
    Austria: A Sil-Holds
    """
    And there should be the following units:
    """
    Germany: A Ber
    Austria: A Sil
    """

  Scenario: Cascading standoffs when two units try to move towards a holding unit
    Given the following board:
      | full name | province | type    | neighbors |
      | Kiel      | Kie      | coastal | Ber       |
      | Berlin    | Ber      | coastal | Kie,Pru   |
      | Prussia   | Pru      | coastal | Ber       |
    And there are the following units:
    """
    Germany: F Kie, A Ber
    Russia: A Pru
    """
    When the following orders are resolved:
    """
    Germany: F Kie-Ber, A Ber-Pru
    Russia: A Pru-Holds
    """
    Then the order resolution report should be:
    """
    Germany: _F_Kie-Ber_, _A_Ber-Pru_
    Russia: A Pru-Holds
    """
    And there should be the following units:
    """
    Germany: F Kie, A Ber
    Russia: A Pru
    """
