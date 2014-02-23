require_relative './spec_helper'

describe Cakes do
  describe 'GET /' do
    before(:each) { get '/' }

    it 'returns an HTTP 200' do
      last_response.status.should eq 200
    end

    it "returns a status message 'ok'" do
      json = JSON.parse(last_response.body)
      json['status'].should eq 'ok'
    end
  end

  describe 'GET /users' do
    it 'returns the Users' do
      2.times { create(:user) }
      get '/users'

      json = JSON.parse(last_response.body)
      json.count.should eq 2
    end
  end

  describe 'POST /users' do
    it 'creates a User' do
      post '/users', {:username => 'test', :password => 'testpassword'}

      User.count.should eq 1
      User.first.username.should eq 'test'
      User.first.password.should eq 'testpassword'
    end
  end

  describe 'GET /users/:username' do
    it 'returns the User' do
      create(:user)
      get '/users/test'

      json = JSON.parse(last_response.body)
      json['username'].should eq 'test'
      json['password'].should eq 'testpassword'
    end
  end

  describe 'GET /users/:username/cakes' do
    it "returns the User's cakes" do
      create(:user_with_cakes)

      get '/users/test/cakes'

      json = JSON.parse(last_response.body)
      json.count.should eq 3
    end
  end

  describe 'POST /users/:username/cakes' do
    it 'creates a Cake for the User' do
      create(:user)
      post '/users/test/cakes', {:name => 'ROFL', :deliciousness => 8}

      user = User.all.first
      cake = user.cakes.first

      cake.name.should eq 'ROFL'
      cake.deliciousness.should eq 8
    end
  end

  describe 'GET /cakes/:username/:cake' do
    it 'returns the Cake' do
      create(:user_with_cakes)
      get '/cakes/test/ROFL'

      json = JSON.parse(last_response.body)
      json['name'].should eq 'ROFL'
      json['deliciousness'].should eq 10
    end
  end
end
