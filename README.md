# WAS Registrar App

[![CircleCI](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/master.svg?style=svg)](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/master)

The WAS Registrar App is a Rails application that:
* Allows a web archivist to update configuration and schedule web archive collections to be fetched.
* Allows a web archivist to monitor fetch workflow outcomes.
* Initiates web archive fetch workflows according to schedule.
* Maintains state for web archive collections.

It includes both HTML and API interfaces.

WAS Registrar App is the successor to the [Web Registrar](https://github.com/sul-dlss/was-registrar).

## Requirements
* Ruby 2.6.3
* Docker / Docker-Compose (optional)
* npm for building assets

## Setup
### To use Postgres container (instead of local Postgres)
```
docker-compose up -d db
```
Note that the databases are stored in the _postgres_data_ directory; delete this directory to erase the databases.

### Setup the db
```
RAILS_ENV=test rake db:create db:migrate
```

## Tests
```
bundle exec rubocop
bundle exec rspec
```

## Run locally
```
docker-compose up -d db
docker-compose run web rake db:setup
docker-compose up -d
```
The app will now be available on [http://localhost:3000](http://localhost:3000).

As you make changes (e.g., to gems), you will need to rebuild the web container:
```
docker-compose stop web
docker-compose build web
docker-compose up -d
```

## Deploying
TODO

## API

### PUT /collections/:druid  Update attributes of a collection
#### body: (json) the attributes to set

##### Example value
```
  {
    last_successful_fetch: '2019-08-16T11:31:00+06:00'
  }
```
