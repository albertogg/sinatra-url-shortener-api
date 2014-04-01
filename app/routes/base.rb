class Base < Sinatra::Application
  configure do
    set :root, File.expand_path('../../../', __FILE__)

    disable :method_override
    disable :protection
    disable :static
  end
end
