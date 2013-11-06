#squawker

Squawker is a Twitter clone I built to learn Rails 4. Much gratitude to [Michael Hartl](https://github.com/mhartl), whose Rails tutorial was a huge help in transitioning from Rails 3. 

## Features

* **Squawks**:		
  All posts are automatically upcased by a validator in the squawk model
* **Follow model**:		
  Track the squawks of people you find interesting (or enraging?)
* **Activity Feed**:		
  Uses a SQL subquery to fetch squawks for a given user, as well as those from followeed (users the given user is following)
* **Forgotten Password**:		
  Uses ActionMailer and SendGrid to send the user a password-reset link
* **"Remember me" option**:		
  On sign-in, elect to install a permanent cookie rather than a temporary one
* **Bootrstrap styling**:		
  Uses Twitter bootrstrap, with some tweaks in SASS
* **Tested**:		
  Test suite written in RSpec, automated with Guard. Users generated with Factory Girl and Faker.