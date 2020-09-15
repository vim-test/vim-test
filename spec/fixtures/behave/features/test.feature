Feature: Behave in vim-test

    Scenario: Behave can be run with vim-test
        Given there is a proper Behave project set up
        When I behave is executed through vim-test
        Then tests are run
