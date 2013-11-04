require 'sinatra'
require 'slim'
require 'sqlite3'
require 'json'
require 'pry'

set :slim, pretty: true

get '/' do
  slim :index
end

get '/temperatures.json' do
  content_type :json

  start_date = params[:start] || (Date.today - 90).to_s
  end_date   = params[:end]   || (Date.today).to_s

  db = SQLite3::Database.open "db/normals.db"
  q = db.prepare "SELECT
                    date, low_normal, high_normal, low_actual, high_actual
                  FROM
                    temperatures
                  WHERE
                    date >= DATE(:start) AND date <= DATE(:end)"
  
  q.bind_param :start, start_date
  q.bind_param :end, end_date

  puts start_date
  puts end_date

  results = q.execute.to_a.collect do |row|
    row[0] = Date.parse(row[0]).strftime("%b %-d") # sqlite can't do this, apparently.
    row
  end

  results.to_json
end
