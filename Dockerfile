FROM ruby:2.6.3-stretch

# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install -y nodejs
RUN apt-get update -qq && \
    apt-get install -y nano build-essential postgresql-client yarn

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
ENV BUNDLER_VERSION 2.0.2
RUN gem install bundler && bundle install
