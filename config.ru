require "bundler/setup"
require "faker"
require "pg"
require "pry"
require "sinatra/base"
# require "sinatra/reloader"

require_relative "server"
run Sinatra::Server
