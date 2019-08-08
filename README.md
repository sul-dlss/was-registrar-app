# WAS Registrar App

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
rake
```

## Run locally
```
docker-compose up -d db
docker-compose run web rake db:setup
docker-compose up -d
```

## Deploying
TODO

## Routes
TODO