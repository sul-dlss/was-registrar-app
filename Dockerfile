FROM ruby:3.3.1-bookworm

RUN curl -fsSL https://deb.nodesource.com/setup_current.x | bash -

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        postgresql-client postgresql-contrib libpq-dev \
        # clang is required for openapi_parser and commonmaker
        clang \
        tzdata nodejs

WORKDIR /app

RUN npm install -g yarn

COPY Gemfile Gemfile.lock /app/
RUN gem install bundler && bundle install

RUN gem install foreman

COPY package.json yarn.lock /app/
RUN yarn install --check-files
COPY . .

CMD ["docker/invoke.sh"]
