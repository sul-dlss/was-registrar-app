FROM ruby:2.6.3-stretch

RUN apt-get update -qq && \
    apt-get install -y nano build-essential postgresql-client nodejs

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler && bundle install
