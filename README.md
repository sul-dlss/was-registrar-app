# WAS Registrar App

[![CircleCI](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/main.svg?style=svg)](https://circleci.com/gh/sul-dlss/was-registrar-app/tree/main)
[![Test Coverage](https://api.codeclimate.com/v1/badges/825ca3f3c2fe04d3319c/test_coverage)](https://codeclimate.com/github/sul-dlss/was-registrar-app/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/825ca3f3c2fe04d3319c/maintainability)](https://codeclimate.com/github/sul-dlss/was-registrar-app/maintainability)

The WAS Registrar App (WRA) is a Rails application that:
* Allows a web archivist to update configuration and schedule web archive collections to be fetched.
* Allows a web archivist to monitor fetch workflow outcomes.
* Initiates web archive fetch workflows according to schedule.
* Maintains state for web archive collections.

WAS Registrar App is the successor to the [Web Registrar](https://github.com/sul-dlss/was-registrar).

## Requirements
* Ruby 3.3.1
* Docker / Docker-Compose (optional)
* npm for building assets
* Java 8ish for [WASAPI Downloader](https://github.com/sul-dlss/wasapi-downloader)

## Setup
### To use Postgres container (instead of local Postgres)
```
docker-compose up -d db
```

### Setup the db
```
RAILS_ENV=test rake db:create db:migrate
```

### To use Redis container (instead of local Redis)
```
docker-compose up -d redis
```

### Install WASAPI Downloader
Note: The WASAPI Downloader is not typically needed for development; it is necessary for running fetches.

```
curl -L https://github.com/sul-dlss/wasapi-downloader/releases/download/v1.1.1/wasapi-downloader.zip > wasapi-downloader.zip
unzip wasapi-downloader.zip
```
If installing in a different location, make the appropriate change in settings.

## Tests
```
bin/rails test:prepare
bundle exec rubocop
bundle exec rspec
```

## Run with docker
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

## Run locally

First install foreman (foreman is not supposed to be in the Gemfile, See this [wiki article](https://github.com/ddollar/foreman/wiki/Don't-Bundle-Foreman) ):

```
gem install foreman
```

Then you can run
```
bin/dev
```
This starts css/js bundling and the development server

Alernatively, you can start use docker compose:
```
docker compose up -d
```

if you want to run the web container in intractive mode, stop it first and then run it so it will show interactive live output:
```
docker compose stop web
docker compose run --service-ports web
```

## Background processing
Background processing is performed by [Sidekiq](https://github.com/mperham/sidekiq).

Sidekiq can be monitored from [/queues](http://localhost:3000/queues).

For more information on configuring and deploying Sidekiq, see this [doc](https://github.com/sul-dlss/DevOpsDocs/blob/main/projects/sul-requests/background_jobs.md).

To run a Sidekiq worker locally:
```
bundle exec sidekiq
```

## Deploying
To deploy to [stage](https://was-registrar-app-stage.stanford.edu): `bundle exec cap stage deploy`

To deploy to [production](https://was-registrar-app.stanford.edu): `bundle exec cap prod deploy`

## Auditing
To audit the WARCs that have been accessioned in SDR against the WARCs available from a WASAPI provider,
use an audit rake task:
* For a collection that is configured in WRA: `bin/rake audit_collection['<collection druid>']`
* For a collection that is not configured in WRA: `bin/rake audit['<collection_druid>','<wasapi_collection_id>','<wasapi_account>','<embargo_months>']`

For example:
```
RAILS_ENV=production bin/rake audit_collection['druid:hw105qf0103']`
RAILS_ENV=production bin/rake audit['druid:gq319xk9269','14373','shl','1']
```

This will return a list of WARC filenames that are available but have not been accessioned. This will respect embargoes
and exclude WARCs from the current month.

## Remediating
To fetch and initiate a one-time registration for missing WARCs (based on the auditing procedure described above),
use a remediate rake task:
* For a collection that is configured in WRA: `bin/rake remediate_collection['<collection druid>']`
* For a collection that is not configured in WRA: `bin/rake remediate['<collection_druid>','<wasapi_collection_id>','<wasapi_account>','<embargo_months>']`

For example:
```
RAILS_ENV=production bin/rake remediate_collection['druid:hw105qf0103']`
RAILS_ENV=production bin/rake remediate['druid:gq319xk9269','14373','shl','1']
```

## Reset Process (for QA/Stage)

### Requirements


### Steps

1. Stop the redis queues: https://was-registrar-app-stage.stanford.edu/queues/
2. [Reset the database](https://github.com/sul-dlss/DeveloperPlaybook/blob/main/best-practices/db_reset.md) including seeding.
3. Verify the default collection has been created and no jobs are reported
4. Run the `web_archive_accessioning_spec` (`bundle exec rspec spec/features/web_archiving_accessioning_spec.rb`) integration test and verify that a `One-time WARC` is created.
5. Verify that `https://library.stanford.edu/sites/all/themes/sulair2016/logo.svg` is indexed: https://swap-stage.stanford.edu/was/*/https://library.stanford.edu/sites/all/themes/sulair2016/logo.svg
