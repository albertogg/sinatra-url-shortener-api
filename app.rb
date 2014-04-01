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
      { "links" => @link}.to_json(except: [:created_at,
                                           :uri_hash,
                                           :updated_at],
                                  methods: [:href])
    end

    post '/links' do
      content_type :json

      request.body.rewind
      json_req = JSON.parse(request.body.read)
      link = json_req['links'].map { |new_link| Link.create_new_link(new_link) }

      Link.transaction do
        status 201
        headers "Location" => link[0].href
        { "links" => link.each(&:save!)}.to_json(except: [:created_at,
                                                          :uri_hash,
                                                          :updated_at],
                                                methods: [:href])
      end
    end
  end
end
