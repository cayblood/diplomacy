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

  Scenario: Invalid move due to non-existent destination
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

  Scenario: Invalid move due to unreachable destination
    Given the following board:
      | full name | province | type   | neighbors       |
      | Vienna    | Vie      | inland | Bud             |
      | Budapest  | Bud      | inland | Vie             |
      | Paris     | Par      | inland | Pic,Bre,Gas,Bur |
    And there are the following units:
    """
    Austria: A Vie
    """
    When the following orders are resolved:
    """
    Austria: A Vie-Par
    """
    Then the order resolution report should be:
    """
    Austria: _A_Vie-Par_
    """
    And there should be the following units:
    """
    Austria: A Vie
    """

  Scenario: Invalid move due to unit not being on designated starting point
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
    Austria: A Bud-Vie
    """
    Then the order resolution report should be:
    """
    Austria: _A_Bud-Vie_
    """
    And there should be the following units:
    """
    Austria: A Vie
    """

  Scenario: Invalid move due to army unit attempting to enter water province
    Given the following board:
      | full name          | province | type    | neighbors |
      | Brest              | Bre      | coastal | Mid       |
      | Mid-Atlantic Ocean | Mid      | water   | Bre       |
    And there are the following units:
    """
    France: A Bre
    """
    When the following orders are resolved:
    """
    France: A Bre-Mid
    """
    Then the order resolution report should be:
    """
    France: _A_Bre-Mid_
    """
    And there should be the following units:
    """
    France: A Bre
    """

  Scenario: Invalid move due to fleet unit attempting to enter inland province
    Given the following board:
      | full name | province | type    | neighbors |
      | Brest     | Bre      | coastal | Par       |
      | Paris     | Par      | inland  | Bre       |
    And there are the following units:
    """
    France: F Bre
    """
    When the following orders are resolved:
    """
    France: F Bre-Par
    """
    Then the order resolution report should be:
    """
    France: _F_Bre-Par_
    """
    And there should be the following units:
    """
    France: F Bre
    """

  Scenario: Invalid move due to ambiguous coast
    Given the following board:
      | full name          | province | type    | neighbors | coasts | coastal neighbors |
      | Mid-Atlantic Ocean | Mid      | water   | Spa       |        |                   |
      | Spain              | Spa      | coastal |           | NC, SC | SC-Mid, NC-Mid    |
    And there are the following units:
    """
    France: F Mid
    """
    When the following orders are resolved:
    """
    France: F Mid-Spa
    """
    Then the order resolution report should be:
    """
    France: _F_Mid-Spa_
    """
    And there should be the following units:
    """
    France: F Mid
    """

  Scenario: Valid move due to specified coast
    Given the following board:
      | full name          | province | type    | neighbors | coasts | coastal neighbors |
      | Mid-Atlantic Ocean | Mid      | water   | Spa       |        |                   |
      | Spain              | Spa      | coastal |           | NC, SC | SC-Mid, NC-Mid    |
    And there are the following units:
    """
    France: F Mid
    """
    When the following orders are resolved:
    """
    France: F Mid-Spa NC
    """
    Then the order resolution report should be:
    """
    France: F Mid-Spa NC
    """
    And there should be the following units:
    """
    France: F Spa NC
    """