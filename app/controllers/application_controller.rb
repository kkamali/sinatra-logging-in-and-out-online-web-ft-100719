require_relative '../../config/environment'
require 'pry'
require_relative '../helpers/helpers'

class ApplicationController < Sinatra::Base
  configure do
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions unless test?
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user.nil?
      erb :error
    else
      session[:user_id] = @user.id

      redirect '/account'
    end
  end

  get '/account' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)

      erb :account
    else
      erb :error
    end
  end

  get '/logout' do
    session.clear

    redirect '/'
  end
end

