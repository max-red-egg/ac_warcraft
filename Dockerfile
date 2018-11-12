# Base image
FROM ruby:2.4.2

# Run these commands
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp

# Create working directory
WORKDIR /myapp

# Copy files to working directory
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp
