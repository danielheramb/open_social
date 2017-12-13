@api @post @stability @critical @database @stability-1 @unique123
Feature: Prevent orphaned posts
  Benefit: When a user is deleted posts should not break

  Background:
    Given users:
      | name      | status | pass |
      | PostCreateUser1 |      1 | PostCreateUser1 |
    And I am logged in as "PostCreateUser1"
    And I am on the homepage
    When I fill in "Say something to the Community" with "This is an existing post."
    And I press "Post"
    Then I should see the success message "Your post has been posted."
    And I should see "This is an existing post."
    And I should see "PostCreateUser1" in the "Main content front"
    And I should be on "/stream"

  Scenario: A user is deleted and content is kept
    Given I am logged in as an "administrator"
    And I am on "/admin/people"
    And I check "Update the user PostCreateUser1"
    And I select "Cancel the selected user account(s)" from "edit-action"
    And I press "Apply to selected items"
    Then I should be on "/admin/people/cancel"
    When I select the radio button "Delete the account and make its content belong to the Anonymous user. Reassign its groups to the super administrator."
    And I press "Cancel accounts"
    And I wait for the batch job to finish
    # Ensure the post still exists but is no longer associated with the user.
    Then I should see "PostCreateUser1 has been deleted"
    When I go to "/stream"
    Then I should see "This is an existing post."
    And I should see "Anonymous" in the "Main content front"
    And I should not see "PostCreateUser1" in the "Main content front"


  Scenario: A user is deleted and content is removed
    Given I am logged in as an "administrator"
    And I am on "/admin/people"
    And I check "Update the user PostCreateUser1"
    And I select "Cancel the selected user account(s)" from "edit-action"
    And I press "Apply to selected items"
    Then I should be on "/admin/people/cancel"
    When I select the radio button "Delete the account, its content and groups."
    And I press "Cancel accounts"
    And I wait for the batch job to finish
    # Ensure the post and user have been removed.
    Then I should see "PostCreateUser1 has been deleted"
    When I go to "/stream"
    Then  I should not see "PostCreateUser1" in the "Main content front"
    And I should not see "This is an existing post."
