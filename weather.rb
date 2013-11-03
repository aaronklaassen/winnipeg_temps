require 'sinatra'
require 'slim'
require 'sqlite3'
require 'json'

set :slim, pretty: true

get '/' do
  slim :index
end

get '/temperatures.json' do
  content_type :json

  db = SQLite3::Database.open "db/normals.db"
  
  q = db.prepare "SELECT
                    date, low_normal, high_normal, low_actual, high_actual
                  FROM temperatures"
  results = q.execute.to_a
  data = results.unshift ["Date", "Normal Low", "Normal High", "Actual Low", "Actual High"]

  data.to_json
end
