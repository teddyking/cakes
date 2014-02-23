# About

I'm learning about [Cloud Foundry](https://github.com/cloudfoundry) :D. Cakes is a hilariously basic, sinatra-based JSON API. It's developed to run on a Cloud Foundry instance. It depends on Mongo for storage and makes use of the MongoLab service provided at [https://api.run.pivotal.io](https://api.run.pivotal.io).

# Deploying
```bash
cf push
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
# assuming Cakes is deployed at http://cakes.cfapps.io

# status
curl http://cakes.cfapps.io

# users
## return all users
curl http://cakes.cfapps.io/users

## return specific user
curl http://cakes.cfapps.io/users/username

## create new user
curl http://cakes.cfapps.io/users -d "username=teddyking&password=testpassword"

# cakes
## return a user's cakes
curl http://cakes.cfapps.io/users/teddyking/cakes

## create a new cake for a user
curl http://cakes.cfapps.io/users/teddyking/cakes -d "name=rofl&deliciousness=10"

## return a specific cake
curl http://cakes.cfapps.io/cakes/teddyking/cakename
```