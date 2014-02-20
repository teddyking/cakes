require 'json'
require 'mongoid'
require 'sinatra/base'

Mongoid.load!('config/mongoid.yml')

class Cakes < Sinatra::Base

  before do
    content_type :json
  end

  get '/' do
    {'status' => 'ok'}.to_json
  end

  get '/users' do
    users = User.all

    {'users' => users}.to_json
  end

  post '/users' do
    user = User.new(username: params[:username], password: params[:password])

    if user.save
      {'user' => user}.to_json
    else
      error do
        {'status' => 'could not save user'}.to_json
      end
    end
  end

  get '/user/:username' do
    user = User.where(username: params[:username]).first
    cakes = user.cakes

    {'user' => user}.to_json
  end

  get '/user/:username/cakes' do
    user = User.where(username: params[:username]).first

    {'user' => user, 'cakes' => user.cakes}.to_json
  end

  post '/user/:username/cakes' do
    user = User.where(username: params[:username]).first

    if user.nil?
      error do
        {'status' => 'could not find user'}.to_json
      end
    end

    cake = Cake.new(name: params[:name], deliciousness: params[:deliciousness])

    if user.cakes << cake
      {'user' => user, 'cakes' => user.cakes}.to_json
    else
      error do
        {'status' => 'could not create cake for user'}.to_json
      end
    end
  end
end

# models
class Cake
  include Mongoid::Document

  field :name
  field :deliciousness, type: Integer

  belongs_to :user, inverse_of: :cakes
end

class User
  include Mongoid::Document

  field :username
  field :password

  has_many :cakes, inverse_of: :user
end
