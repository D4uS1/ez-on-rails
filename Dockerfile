FROM ruby:3.0.2
RUN apt-get update -qq && apt-get install -y build-essential
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - && apt-get install -y nodejs
RUN npm install --global yarn
RUN apt-get install -y vim python2
RUN mkdir /EzOnRailsTest
WORKDIR /EzOnRailsTest
COPY . /EzOnRailsTest
RUN bundle install