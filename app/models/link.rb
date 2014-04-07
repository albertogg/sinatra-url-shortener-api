class Link < ActiveRecord::Base
  before_create :set_uri_hash

  validates :uri, presence: true

  def self.search_by(params)
    if params.is_number?
      select(:uri, :uri_hash).where(id: params)
    else
      select(:uri, :uri_hash).where(uri_hash: params)
    end
  end

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

  def self.return_header_location(params)
    ids = params[:links].map(&:id).join(',')
    if ids.length > 2
      "/?ids=#{ids}"
    else
      "/#{ids}"
    end
  end

  def self.save_received_request(links)
    transaction do
      begin
        { links: links.each(&:save!) }
      rescue ActiveRecord::RecordInvalid => invalid
        { error: invalid.record.errors }
      end
    end
  end
end
