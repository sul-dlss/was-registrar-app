FROM ruby:3.0

# https://github.com/nodesource/distributions#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
    && apt-get install -y nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && \
    apt-get install -y nano build-essential postgresql-client yarn

WORKDIR /app

ADD Gemfile Gemfile.lock package.json yarn.lock /app/

ENV BUNDLER_VERSION 2.3.4
RUN gem install bundler && bundle install
RUN yarn install --check-files
COPY . .

CMD puma -C config/puma.rb
