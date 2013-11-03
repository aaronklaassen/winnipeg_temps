require 'sinatra'
require 'slim'
require 'sqlite3'

set :slim, pretty: true

get '/' do
  db = SQLite3::Database.open "db/normals.db"
  db.results_as_hash = true

  q = db.prepare "SELECT * FROM temperatures"
  q.execute

  slim :index
end

get '/temperatures.json' do
  '[    ["Year", "Figure", "Two"],
        ["2012",  1000,      400],
        ["2013",  1170,      460],
        ["2014",  660,       1120],
        ["2015",  1030,      540]]'
end
