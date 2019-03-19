Feature: Numbers
  Scenario: Addition
    When I add 1 and 1
    Then I should get 2

  Scenario Outline: Substraction
    When I substract 1 from 2
    Then A should get 1

  Scenario: Multiplication
    When I multiply 2 and 2
    Then I should get 4
