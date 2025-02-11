*** Settings ***
Library    BuiltIn
Documentation    This is a test suite.


*** Test Cases ***
Normal Test
    [Documentation]    This is a normal test.
    ${result}=    Evaluate    1 + 1
    Should Be Equal    ${result}    2

Normal Test 2
    [Documentation]    This is a normal test.
    ${result}=    Evaluate    1 + 2
    Should Be Equal    ${result}    3


*** Keywords ***
sample keyword
    [Arguments]    ${arg1}
    [Documentation]    This is a sample keyword not possible to run.
    Log    ${arg1}
