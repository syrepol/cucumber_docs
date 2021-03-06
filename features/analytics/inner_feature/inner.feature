Feature: Inner feature

  Lorem ipsum dolor sit amet

  Background:
    When i prepare request to "https://dev.appnxt.net/analytics"

  Scenario Outline: i send correct POST requests to different endpoints
    Given i chose "<endpoint>"
    When read request data from "<requestFileName>"
    Then i send POST request
    And status code is "<statusCode>"
    And response data is the same as in "<responseFileName>"

    Examples: Success

      | endpoint            | requestFileName                       | responseFileName  | statusCode |
      | /installed          | requestDataEPInstalled.json           | responseBody.json | 200        |
      | /opened             | requestDataEPOpened.json              | responseBody.json | 200        |
      | /suggested-clicked  | requestDataEPSuggested-clicked.json   | responseBody.json | 200        |
      | /template-displayed | requestDataEPTemplate-displayed1.json | responseBody.json | 200        |
      | /template-displayed | requestDataEPTemplate-displayed2.json | responseBody.json | 200        |
      | /cached             | requestDataEPActions.json             | responseBody.json | 200        |
      | /displayed          | requestDataEPActions.json             | responseBody.json | 200        |
      | /clicked            | requestDataEPActions.json             | responseBody.json | 200        |
      | /displayed_expired  | requestDataEPActions.json             | responseBody.json | 200        |
      | /expired            | requestDataEPActions.json             | responseBody.json | 200        |


    Examples: Failure

      | endpoint            | requestFileName                           | responseFileName      | statusCode |
      | /installed          | requestFailDataEPInstalled.json           | responseFailBody.json | 400        |
      | /opened             | requestFailDataEPOpened.json              | responseFailBody.json | 400        |
      | /suggested-clicked  | requestFailDataEPSuggested-clicked.json   | responseFailBody.json | 400        |
      | /template-displayed | requestFailDataEPTemplate-displayed1.json | responseFailBody.json | 400        |
      | /template-displayed | requestFailDataEPTemplate-displayed2.json | responseFailBody.json | 400        |
      | /cached             | requestFailDataEPActions.json             | responseFailBody.json | 400        |
      | /displayed          | requestFailDataEPActions.json             | responseFailBody.json | 400        |
      | /clicked            | requestFailDataEPActions.json             | responseFailBody.json | 400        |
      | /displayed_expired  | requestFailDataEPActions.json             | responseFailBody.json | 400        |
      | /expired            | requestFailDataEPActions.json             | responseFailBody.json | 400        |