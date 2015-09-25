require_relative '../data_mapper_setup'
require 'sinatra/base'

class Chitter < Sinatra::Base
  set :views, proc{File.join(root, '..' , 'views')}
  enable :sessions
  set :session_secret, 'super secret'

  get '/' do
    @peeps = Peep.all
    erb :index
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                first_name: params[:first_name],
                last_name: params[:last_name],
                username: params[:username])
    session[:user_id] = @user.id
    redirect to('/')
  end

  helpers do
    def current_user
      User.get(session[:user_id])
    end
  end

end
