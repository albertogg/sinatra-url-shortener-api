class Link < ActiveRecord::Base
  def self.create_new_link(params)
    link = Link.new
    link.uri = params['uri']
    link.uri_hash = params['uri_hash']
    link.viewed = params['viewed']
    link
  end
end
