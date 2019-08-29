# WAS Registrar App

[![CircleCI](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/master.svg?style=svg)](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/master)
[![Test Coverage](https://api.codeclimate.com/v1/badges/825ca3f3c2fe04d3319c/test_coverage)](https://codeclimate.com/github/sul-dlss/was-registrar-app/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/825ca3f3c2fe04d3319c/maintainability)](https://codeclimate.com/github/sul-dlss/was-registrar-app/maintainability)

The WAS Registrar App is a Rails application that:
* Allows a web archivist to update configuration and schedule web archive collections to be fetched.
* Allows a web archivist to monitor fetch workflow outcomes.
* Initiates web archive fetch workflows according to schedule.
* Maintains state for web archive collections.

WAS Registrar App is the successor to the [Web Registrar](https://github.com/sul-dlss/was-registrar).

## Requirements
* Ruby 2.6.3
* Docker / Docker-Compose (optional)
* npm for building assets
* Java 8ish for [WASAPI Downloader](https://github.com/sul-dlss/wasapi-downloader)

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

### Install WASAPI Downloader
Note: The WASAPI Downloader is not typically needed for development; it is necessary for running fetches.

```
curl -L https://github.com/sul-dlss/wasapi-downloader/releases/download/v1.1.0/wasapi-downloader.zip > wasapi-downloader.zip
unzip wasapi-downloader.zip
```
If installing in a different location, make the appropriate change in settings.

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

## Background processing
Background processing is performed by [Sidekiq](https://github.com/mperham/sidekiq).

Sidekiq can be monitored from [/queues](http://localhost:3000/queues).

For more information on configuring and deploying Sidekiq, see this [doc](https://github.com/sul-dlss/DevOpsDocs/blob/master/projects/sul-requests/background_jobs.md).

## Deploying
TODO
