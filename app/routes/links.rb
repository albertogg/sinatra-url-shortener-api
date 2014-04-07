module Routes
  module Api
    module V1
      class Links < Base
        before do
          content_type :json
        end

        get '/' do
          { links: Link.by_ids(params[:ids])}.to_json(except: [:created_at,
                                                               :uri_hash,
                                                               :updated_at],
                                                     methods: [:href])
        end

        get '/:search' do
          { links: Link.search_by(params[:search])}.to_json(except: [:uri_hash],
                                                               methods: [:href])
        end

        post '/' do
          request.body.rewind
          json_req = JSON.parse(request.body.read)
          links = json_req['links'].map { |new_link| Link.create_new_link(new_link) }

          saved_links = Link.save_received_request(links)
          if saved_links.has_key?(:error)
            status 400
            saved_links.to_json
          else
            status 201
            headers "Location" => Link.return_header_location(saved_links)
            saved_links.to_json(except: [:created_at,:uri_hash, :updated_at],
                               methods: [:href])
          end
        end
      end
    end
  end
end
