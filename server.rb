module Sinatra
  class Server < Sinatra::Base
    set :method_override, true
    enable :sessions
   require 'pg'
   require 'bcrypt'


    def login
    session[:user_id]
    true
    end

    get "/" do
    erb :signup
    end

    get "/login" do
      @email = params[:email]
      @password = params[:password]
      erb :login
    end

    post "/signup" do
      @email = params[:email]
      @password = BCrypt::Password::create(params[:password])
      conn.exec_params(
        "INSERT INTO users (email, password)
        VALUES ($1, $2)",
        [@email, @password]
      )
      redirect to("/login")
    end

    post "/login" do
      @email = params[:email]
      @password = params[:password]

      @user = conn.exec_params(
        "SELECT * FROM users WHERE email=$1 LIMIT 1",
        [@email]
      ).first
      if @user && BCrypt::Password::new(@user["password"]) == params[:password]
        "You have successfully logged in"
        session[:user_id] = @user_id
        redirect to('/threads')
      else
        "Wrong password!!"
        redirect to('/login')
      end

    end

    # get "/users" do
    #  @users = db.exec("SELECT * FROM users;")
    #   erb :index
    # end

    get "/users/:id" do
    id = params[:id]
    @users = db.exec_params("SELECT * FROM users WHERE id = $1",[id])
    erb :index
    end

     get "/threads" do
      @threads = conn.exec("SELECT * FROM threads")
      erb :category
    end

    post "/threads" do
      conn.exec_params("INSERT INTO threads (topic) VALUES ($1)", [topic])
      redirect to("/threads")
    end

    # get "/categories" do
    #  @categories = db.exec("SELECT * FROM categories;")
    #   erb :category
    # end

    # get "/categories/:id" do
    # id = params[:id]
    # @categories = db.exec("SELECT * FROM categories WHERE id = #{id};")
    # erb :category
    # end

    # post "/categories" do
    #   conn.exec_params("INSERT INTO categories (name) VALUES ($1)", [name])
    #   redirect to("/categories")
    # end

    # post "/categories" do
    #   conn.exec_params("INSERT INTO categories (Places_to_visit) VALUES ($)", [Places_to_visit])
    #   redirect to ("/categories")
    # end

    # get "/places" do
    # @places = db.exec("SELECT * FROM places;")
    # erb :place
    # end

    # get "/places/:name" do
    # name = params[:name]
    # @places = db.exec("SELECT name FROM places WHERE name = #{name};")
    # erb :place
    # end

    def conn
         if ENV["RACK_ENV"] == "production"
            PG.connect(
                dbname: ENV["POSTGRES_DB"],
                host: ENV["POSTGRES_HOST"],
                password: ENV["POSTGRES_PASS"],
                user: ENV["POSTGRES_USER"]
             )
        else
      PG.connect(dbname: "travel")
      end
    end
  end
end
