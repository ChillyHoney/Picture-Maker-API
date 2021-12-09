# README

# Ruby version
``` ruby:2.6-buster ```

# How to start project first time

``` docker-compose up --build ```

``` docker-compose run web rails db:create ```

``` docker-compose run web rails db:migrate ```

# How to start docker

``` docker-compose up --build ```

# How to run the test suite

Using docker
``` docker-compose run web bundle exec rspec -f d ```

Using locally
``` bundle exec rspec -f d ```

