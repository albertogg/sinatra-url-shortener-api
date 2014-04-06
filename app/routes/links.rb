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

        get '/:search' do
          { "links" => Link.search_by(params[:search])}.to_json(except: [:id,
                                                                        :uri_hash],
                                                               methods: [:href])
        end

        post '/' do
          request.body.rewind
          json_req = JSON.parse(request.body.read)
          links = json_req['links'].map { |new_link| Link.create_new_link(new_link) }

          Link.transaction do
            begin
              status 201
              saved_links = links.each(&:save!)
              headers "Location" => Link.return_header_location(saved_links)
              { "links" => saved_links}.to_json(except: [:created_at,
                                                         :uri_hash,
                                                         :updated_at],
                                                methods: [:href])
            rescue ActiveRecord::RecordInvalid => invalid
              status 400
              { :error => invalid.record.errors }.to_json
            end
          end
        end
      end
    end
  end
end
