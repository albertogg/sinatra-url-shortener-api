class Link < ActiveRecord::Base
  def self.by_ids(params)
    if params.present?
      where(id: params.split(','))
    else
      all
    end
  end

  def self.create_new_link(params)
    link = Link.new
    link.uri = params['uri']
    link.uri_hash = params['uri_hash']
    link.viewed = params['viewed']
    link
  end

  def href
    "#{ENV['URL']}/#{uri_hash}"
  end
end
