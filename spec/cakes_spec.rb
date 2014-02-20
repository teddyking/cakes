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
      json['users'].count.should eq 2
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

  describe 'GET /user/:username' do
    it 'returns the User' do
      create(:user)
      get '/user/test'

      json = JSON.parse(last_response.body)
      json['user']['username'].should eq 'test'
      json['user']['password'].should eq 'testpassword'
    end
  end

  describe 'GET /user/:username/cakes' do
    it "returns the User's cakes" do
      create(:user_with_cakes)

      get '/user/test/cakes'

      json = JSON.parse(last_response.body)
      json['user']['username'].should eq 'test'
      json['cakes'].count.should eq 3
    end
  end

  describe 'POST /user/:username/cakes' do
    it 'creates a Cake for the User' do
      create(:user)
      post '/user/test/cakes', {:name => 'ROFL', :deliciousness => 8}

      user = User.all.first
      cake = user.cakes.first

      cake.name.should eq 'ROFL'
      cake.deliciousness.should eq 8
    end
  end
end
