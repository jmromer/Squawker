squawker
========

[![Code Climate Badge][]][Code Climate]

[Code Climate Badge]: https://codeclimate.com/github/jkrmr/Squawker/badges/gpa.svg
[Code Climate]: https://codeclimate.com/github/jkrmr/Squawker

A Twitter clone.


Features
--------

* **Squawks**:
  All posts are automatically upcased by a `before_action` in the `Squawk` model.
  Case-sensitive hyperlinks are left unmodified.
* **Follow model**:
  Track the squawks of people you find interesting (enraging?)
* **Activity Feed**:
  Fetches squawks for a given user, as well as those from the user's 'followees'
  (users the given user is following)
* **Forgotten Password**:
  Uses ActionMailer and SendGrid to send the user a password-reset link
* **"Remember me" option**:
  On sign-in, elect to install a permanent cookie rather than a temporary one
* **Character countdown**:
  Shows remaining number of available characters (maximum: 160 --- 20 more than
  Twitter!)
* **Tested**:
  Test suite written in RSpec.

