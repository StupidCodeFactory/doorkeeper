require 'doorkeeper/oauth/client_credentials/validation'

module Doorkeeper
  module OAuth
    class ClientCredentialsRequest
      class Issuer
        attr_accessor :token, :validation, :error

        def initialize(server, validation)
          @server, @validation = server, validation
        end

        def create(client, scopes, creator = Doorkeeper::AccessToken.method(:create))
          if validation.valid?
            @token = create_token(client, scopes, creator)
            @error = :server_error unless @token
          else
            @token = false
            @error = validation.error
          end
          @token
        end

        private

        def create_token(client, scopes, creator)
          creator.call({
            :application_id    => client.id,
            :resource_owner_id => client.id,
            :scopes            => scopes.to_s,
            :use_refresh_token => false,
            :expires_in        => @server.access_token_expires_in
          })
        end
      end
    end
  end
end
