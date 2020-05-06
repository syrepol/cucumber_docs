@actions
Feature: Displayed endpoint

  Client is supposed to send data to "/analytics/displayed" after showing list of actions on the screen.

  Background:
    When i prepare request to "http://dev.appnxt.net/analytics"

  Scenario Outline: i send  correct POST requests and expect success result
    Given i chose "<endpoint>"
    When read request data from "<requestFileName>"
    Then i send POST request
    And status code is "<statusCode>"
    And response data is the same as in "<responseFileName>"

    Examples: Success

      | endpoint   | requestFileName | responseFileName  | statusCode |
      | /displayed | actions.json    | responseBody.json | 200        |


  @negative
  Scenario Outline: i send  incorrect POST requests and expect fail  result
    Given i chose "<endpoint>"
    When read bad request data from "<requestFailFileName>"
    Then i send POST request
    And status code is "<statusCode>"
    And response bad data is the same as in "<responseFailFileName>"

    Examples: Failure

      | endpoint   | requestFailFileName | responseFailFileName  | statusCode |
      | /displayed | failActions1.json   | responseFailBody.json | 400        |
      | /displayed | failActions2.json   | responseFailBody.json | 400        |
      | /displayed | failActions3.json   | responseFailBody.json | 400        |
      | /displayed | failActions4.json   | responseFailBody.json | 400        |