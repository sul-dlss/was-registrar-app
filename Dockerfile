FROM ruby:3.0-alpine

RUN apk add --update --no-cache \
  build-base \
  postgresql-dev \
  postgresql-client \
  tzdata \
  yarn

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler && bundle install

COPY package.json yarn.lock /app/
RUN yarn install --check-files
COPY . .

CMD puma -C config/puma.rb
