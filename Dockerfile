FROM ruby:3.3.5
RUN apt-get update -qq && apt-get install -y build-essential
RUN apt-get install -y vim
RUN mkdir /ez-on-rails
WORKDIR /ez-on-rails
COPY . /ez-on-rails

RUN gem install bundler # needed by rubymine
RUN bundle install