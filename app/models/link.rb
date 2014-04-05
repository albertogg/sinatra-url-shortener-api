class Link < ActiveRecord::Base
  before_create :set_uri_hash

  validates :uri, presence: true

  scope :by_uri_hash, -> params { select(:uri).where(uri_hash: params) }

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
    link
  end

  def href
    "http://#{$host_port}/#{uri_hash}"
  end

  def set_uri_hash
    self.uri_hash = rand(36**5).to_s(36)
  end
end
