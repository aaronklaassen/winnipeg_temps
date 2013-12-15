require 'sinatra'
require 'slim'
require 'sqlite3'
require 'json'
require 'nokogiri'
require 'httparty'
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
                    date, high_normal, low_normal, high_actual, low_actual
                  FROM
                    temperatures
                  WHERE
                    date >= DATE(:start) AND date <= DATE(:end)"
  
  q.bind_param :start, start_date
  q.bind_param :end, end_date

  results = q.execute.to_a.collect do |row|
    date = Date.parse(row[0])
    row << (date == Date.today ? get_current_temp : nil)
    
    row[0] = date.strftime("%b %-d") # sqlite can't do this, apparently.
    row
  end

  results.to_json
end

private

def get_current_temp
  url = "http://weather.gc.ca/city/pages/mb-38_metric_e.html"
  page = Nokogiri::HTML(HTTParty.get(url))
  page.css(".temperature").inner_text.split("°").first.to_i
end