# BugYourCongressman Application

An app built to help people contact their congressman about ending qualified
immunity in 2020.

The original idea for this project came from a previous app built by Ian Webster.
He outlines that project [here](https://www.twilio.com/blog/2011/04/callcongress-makes-it-easy-to-call-your-senators-and-representatives.html).
This website updates the needed APIs and gives focus to the Civil Rights movement
taking place in 2020.

## Local Setup

### Clone the Repository

```shell
git clone git@github.com:frankolson/bugyourcongressman.git
cd trainer-classroom
```

### Build and Serve the Application

Next, you need to build and run the docker image included in the project
repository. The `-d` flag on the [`docker-compose up`](https://docs.docker.com/compose/reference/up/) will run docker as a background daemon

If you are not familiar with Docker, brush up on it
[here](https://docs.docker.com/develop/).

```shell
docker-compose build
docker-compose up -d
```

The application should now be up and running, but you still need to setup the
database.

### Initialize the Database

Now, you need to create the database and run the migrations.

```shell
docker-compose run web rails db:create db:migrate
```

### Stop the Application

To stop the application, run
[`docker-compose down`](https://docs.docker.com/compose/reference/down/) in your
project directory

```shell
docker-compose down
```

## Running the Test Suite

### Unit Tests

```
docker-compose run web bin/rails test
```

or

```
docker-compose run web bash

bin/rails test
```

### System Tests

```
docker-compose run web bin/rails test:system
```

or

```
docker-compose run web bash

bin/rails test:system
```

## Deploy

Pushes to master will trigger a deploy of the master branch to Heroku. If any
new migrations are present, those will be run before the new release is
deployed.

```
git push origin master
```
