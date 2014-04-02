module Routes
  module Api
    module V1
      class Links < Base
        before do
          content_type :json
        end

        get '/' do
          { "links" => Link.by_ids(params[:ids])}.to_json(except: [:created_at,
                                                                   :uri_hash,
                                                                   :updated_at],
                                                          methods: [:href])
        end

        get '/:uri_hash' do
          { "links" => Link.by_uri_hash(params[:uri_hash])}.to_json(except: :id)
        end

        post '/' do
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
              e
            end
          end
        end
      end
    end
  end
end
