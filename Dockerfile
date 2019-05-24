FROM ruby:2.5.4-stretch

RUN apt-get update -qq && \
    apt-get install -y nano build-essential postgresql-client nodejs

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
ENV BUNDLER_VERSION 2.0.1
RUN gem install bundler && bundle install