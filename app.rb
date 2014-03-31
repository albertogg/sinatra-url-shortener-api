require 'rubygems'
require 'bundler'

Bundler.require
$: << File.expand_path('../', __FILE__)

require 'sinatra/base'
require 'sinatra/reloader' if development?

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
