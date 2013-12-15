#squawker

A Twitter clone.

## Features

* **Squawks**:     
  All posts are automatically upcased by a `before_action` in the `Squawk` model. Case-sensitive hyperlinks are left unmodified.
* **Follow model**:     
  Track the squawks of people you find interesting (or enraging?)
* **Activity Feed**:     
  Uses a SQL subquery to fetch squawks for a given user, as well as those from followees (users the given user is following)
* **Forgotten Password**:     
  Uses ActionMailer and SendGrid to send the user a password-reset link
* **"Remember me" option**:     
  On sign-in, elect to install a permanent cookie rather than a temporary one
* **Bootstrap**:     
  Uses Twitter bootrstrap, with some tweaks in SASS
* **Character countdown**:       
  Shows remaining number of available characters (maximum: 160)
* **Tested**:     
  Test suite written in RSpec, automated with Guard.
