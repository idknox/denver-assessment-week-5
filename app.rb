require "sinatra"
require "./lib/database"
require "./lib/contact_database"
require "./lib/user_database"

class ContactsApp < Sinatra::Base
  enable :sessions

  def initialize
    super
    @contact_database = ContactDatabase.new
    @user_database = UserDatabase.new

    jeff = @user_database.insert(username: "Jeff", password: "jeff123")
    hunter = @user_database.insert(username: "Hunter", password: "puglyfe")

    @contact_database.insert(:name => "Spencer", :email => "spen@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Jeff D.", :email => "jd@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Mike", :email => "mike@example.com", user_id: jeff[:id])
    @contact_database.insert(:name => "Kirsten", :email => "kirsten@example.com", user_id: hunter[:id])
  end

  get "/" do
    if session[:id]
      erb :loggedin, :locals => {:cur_user => @user_database.find(session[:id])[:username], :contacts => @contact_database.find_for_user(session[:id])}
    else
      erb :loggedout
    end
  end

  get "/login" do
    erb :login
  end

  post "/" do

    session[:id] = get_id(params[:username])
    redirect "/"
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  private

  def get_id(username)
    val_users = @user_database.all.select {|user| user[:username] == username}
    if val_users != []
      val_users[0][:id]
    end
  end

end
