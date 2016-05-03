module Sinatra
  class Server < Sinatra::Base
    set :method_override, true
    enable :sessions
   require 'pg'
   require 'bcrypt'

   def current_user
      if session['user_id']
        @current_user ||= conn.exec_params("SELECT * FROM users WHERE id = $1", [session["user_id"]]).first
      else
        # nothing
      end
    end

    # def login
    #   session[:user_id]
    #   true
    # end

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
      @user = conn.exec_params("SELECT * FROM users WHERE email=$1 LIMIT 1",[@email]).first

      if @user
        if BCrypt::Password::new(@user["password"]) == params[:password]
          "You have successfully logged in"
          session[:user_id] = @user['id']
          user = session[:user_id]
          @user = conn.exec_params("SELECT * FROM users WHERE id = $1",[user])

          redirect to("/users/#{user}")

        else
          redirect to('/login')
        end
      else
        "Wrong password!!"
        redirect to('/login')
      end

    end

    get '/logout' do
      session.delete('user_id')
      redirect '/'
    end

    # get "/users" do
    #  @users = db.exec("SELECT * FROM users;")
    #   erb :index
    # end

    get "/users/:id" do
      id = params[:id]
      @places = conn.exec_params("SELECT * FROM places WHERE user_id = $1",[id])
      @categories = conn.exec_params("SELECT * FROM categories")
      @user= conn.exec_params("SELECT * FROM users WHERE id = $1",[id]).first
      erb :index
    end

    #  get "/threads" do
    #   @threads = conn.exec("SELECT * FROM threads")
    #   erb :category
    # end

    # post "/threads" do
    #   conn.exec_params("INSERT INTO threads (topic) VALUES ($1)", [topic])
    #   redirect to("/threads")
    # end

    get "/categories" do
     @categories = conn.exec("SELECT * FROM categories;")
      erb :category
    end

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

    get "/places" do
      @places = conn.exec("SELECT * FROM places;")
      @users = conn.exec("SELECT * FROM users;")
      @categories = conn.exec("SELECT * FROM categories;")
      erb :place
    end

    post "/places" do
      @category_id = params[:category_id].to_i
      @user_id = params[:user_id].to_i
      @name = params[:name]
      @date_of_visit = params[:date_of_visit]
      @description = params[:description]

      if @date_of_visit.length < 1
        @date_of_visit = "N/A"
      end

      conn.exec_params(
        "INSERT INTO places (category_id, name, user_id, date_of_visit, description)
        VALUES ($1, $2, $3, $4, $5)",
        [@category_id, @name, @user_id, @date_of_visit, @description]
      )
      redirect to("/places")
    end


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
