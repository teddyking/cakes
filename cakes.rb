require 'json'
require 'mongoid'
require 'sinatra/base'

Mongoid.load!('config/mongoid.yml')

class Cakes < Sinatra::Base

  before do
    content_type :json
  end

  helpers do
    def check_nil(resource)
      if resource.nil?
        not_found
      end
    end
  end

  get '/' do
    {'status' => 'ok'}.to_json
  end

  get '/users' do
    users = User.all

    users.to_json
  end

  post '/users' do
    user = User.new(username: params[:username], password: params[:password])
    check_nil(user)

    if user.save
      user.to_json
    else
      error do
        {'status' => 'could not save user'}.to_json
      end
    end
  end

  get '/users/:username' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    user.to_json
  end

  delete '/users/:username' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    user.cakes.each do |cake|
      cake.delete
    end

    user.delete
    {}.to_json
  end

  get '/users/:username/cakes' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    user.cakes.to_json
  end

  post '/users/:username/cakes' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    cake = Cake.new(name: params[:name], deliciousness: params[:deliciousness])

    if user.cakes << cake
      cake.to_json
    else
      error do
        {'status' => 'could not create cake for user'}.to_json
      end
    end
  end

  get '/cakes/:username/:cake' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    cake = user.cakes.select { |c| c.name.eql?(params[:cake]) }.first
    check_nil(cake)

    cake.to_json
  end

  delete '/cakes/:username/:cake' do
    user = User.where(username: params[:username]).first
    check_nil(user)

    cake = user.cakes.select { |c| c.name.eql?(params[:cake]) }.first
    check_nil(cake)

    cake.delete
    {}.to_json
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
