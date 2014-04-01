class Links < Base
  get '/links' do
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
    links = json_req['links'].map { |new_link| Link.create_new_link(new_link) }

    Link.transaction do
      begin
        status 201
        saved_links = links.each(&:save!)
        headers "Location" => "links?ids=#{saved_links.map(&:id).join(',')}"
        { "links" => saved_links}.to_json(except: [:created_at,
                                                   :uri_hash,
                                                   :updated_at],
                                          methods: [:href])
      rescue Exception => e
        status 400
      end
    end
  end
end
