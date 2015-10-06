require_relative '../data_mapper_setup'
require 'sinatra/base'
require 'sinatra/flash'

class Chitter < Sinatra::Base
  set :views, proc{File.join(root, '..' , 'views')}
  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'
  use Rack::MethodOverride

  get '/' do
    @peeps = Peep.all
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                first_name: params[:first_name],
                last_name: params[:last_name],
                username: params[:username],
                password: params[:password],
                password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  post '/sessions' do
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      session[:username] = user.username
      redirect to('/')
    else
      flash.now[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  delete '/sessions' do
    session.clear
    flash[:notice] = "You have successfully signed out, goodbye!"
    redirect to('/')
  end

  get '/peeps/new' do
    if session[:user_id] == nil
      flash[:notice] = "You must be logged in to access that page"
      redirect to('/')
    else
      erb :'peeps/new'
    end
  end

  post '/peeps/new' do
    user = User.first(id: session[:user_id])
    user.peeps.create(content: params[:peep])
    redirect to('/')
  end

  helpers do
    def current_user
      User.get(session[:user_id])
    end
  end

end
