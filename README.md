# README

# Ruby version
``` ruby:2.6-buster ```

# How to start project first time

``` docker compose up --build ```

``` docker compose run web rails db:create ```

``` docker compose run web rails db:migrate ```

Pendning migrations problems?

``` docker compose run web rails db:test:prepare ```

# How to start docker

``` docker compose up --build ```

And how to stop docker:

``` docker compose down ```

# How to run the test suite

Using docker
``` docker compose run web bundle exec rspec -f d ```

Using locally
``` bundle exec rspec -f d ```

# How to confirm new user by email

Drag and drop rich.html to the internet browser to see an verification email
``` tmp\letter_opener\long-string\rich.html ```


