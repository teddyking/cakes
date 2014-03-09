# About

I'm learning about [Cloud Foundry](https://github.com/cloudfoundry) :D. cakes is a hilariously basic, sinatra-based JSON API. It's developed to run on a Cloud Foundry instance. It depends on a MongoDB service that's implemented using [this](https://github.com/teddyking/mongodb_broker) service broker.

# Deploying
```bash
# Check that the mongodb service broker is available
cf m

# Create a new mongodb service
cf cs mongodb free my-mongodb

# Push the app
cf push cakes

# Bind the service to the app
cf bs cakes my-mongodb

# Re-push to pick up changes
cf push cakes
```
# Scaling
```bash
cf scale cakes
```

# Testing
```bash
# ensure you have a local copy of Mongo running, then
bundle install
bundle exec rspec -c -f d
```

# Usage
```bash
# assuming cakes is deployed at http://cakes.cfapps.io

# status
curl http://cakes.cfapps.io

# users
## return all users
curl http://cakes.cfapps.io/users

## return specific user
curl http://cakes.cfapps.io/users/<username>

## create new user
curl http://cakes.cfapps.io/users -d "username=teddyking&password=testpassword"

# cakes
## return a user's cakes
curl http://cakes.cfapps.io/users/<username>/cakes

## create a new cake for a user
curl http://cakes.cfapps.io/users/<username>/cakes -d "name=rofl&deliciousness=10"

## return a specific cake
curl http://cakes.cfapps.io/cakes/<username>/<cakename>

## delete a cake
curl -X DELETE http://cakes.cfapps.io/cakes/<username>/<cakename>
```