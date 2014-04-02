require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'
require 'sinatra/reloader' if development? # sinatra-contrib
require 'sinatra/activerecord'

require 'app/models/link'
require 'app/routes/base'
require 'app/routes/links'

module Shortened
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    configure :development do
      register Sinatra::Reloader
    end

    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "sqlite3:///db/shortened_#{environment}.sqlite3"
      }
    end

    use Routes::Api::V1::Links
  end
end
