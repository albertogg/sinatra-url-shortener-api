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

    get '/' do
      @link = Link.all
      @link.to_json
    end

    post '/links' do
      content_type :json

      request.body.rewind
      json_req = JSON.parse(request.body.read)
      link = json_req['link'].map { |links| Link.create_new_link(links) }

      Link.transaction do
        link.each(&:save!).to_json
      end
    end
  end
end
