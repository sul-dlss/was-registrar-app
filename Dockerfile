FROM ruby:3.2.2-alpine

RUN apk add --update --no-cache \
  build-base \
  postgresql-dev \
  postgresql-client \
  tzdata \
  yarn

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler && bundle install

RUN gem install foreman

COPY package.json yarn.lock /app/
RUN yarn install --check-files
COPY . .

CMD ["docker/invoke.sh"]
