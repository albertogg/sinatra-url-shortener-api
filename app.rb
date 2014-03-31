require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load

require 'sinatra/base'
require 'sinatra/reloader' if development? # sinatra-contrib

module Shortened
  class App < Sinatra::Base
    configure :development do
      register Sinatra::Reloader
    end

    get '/' do
      'Hello, World!!'
    end
  end
end
