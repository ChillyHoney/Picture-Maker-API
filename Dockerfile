FROM ruby:2.6-buster

# RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
# changed line due to causing postgresql errors on windows 10
RUN apt-get update -qq && apt-get install -y postgresql-client libpq-dev

# Set the workdir inside the container
WORKDIR /usr/src/app

# Set the gemfile and install
COPY Gemfile* ./
RUN bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . ./

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["rails", "server", "-b", "0.0.0.0"]

