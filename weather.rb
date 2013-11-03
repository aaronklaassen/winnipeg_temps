require 'sinatra'
require 'slim'

set :slim, pretty: true

get '/' do
  # load db


  slim :index
end