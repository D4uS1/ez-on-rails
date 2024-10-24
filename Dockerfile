FROM ruby:3.3.5
RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y vim
RUN mkdir /EzOnRailsTest
WORKDIR /EzOnRailsTest
COPY . /EzOnRailsTest
RUN bundle install