class Api::V1::ApplicationController < ActionController:: API
    before_action :authenticate

    include ActionController::HttpAuthentication::Token::ControllerMethods
    def authenticate
        #handles authenticating a user
        authenticate_token || render_unauthorized
    end

    def authenticate_token
        @ip = request.remote_ip || 'unknown'

        authenticate_with_http_token do |token, _option|
            @token = Token.find_by(value: token)

            if @token.nil?
                render_unauthorized
            else
                if @token.expiry.after?(DateTime.now) && @token.revocation_date.blank?
                    @current_user = @token.user
                    @current_user
                else
                    render_unauthorized
                end
            end
        end
    end

    def render_unauthorized
        logger.debug "***UNAUTHORIZED REQUEST***"
        render_error(errors: "Bad Credentials", status: 401)

        #This is an alternative option.
        # render json: {error: "Bad Credentials", status: 401}, status: 401
    end

    def render_error(errors:, status: :internal_server_error)
        render json: {
            errors: errors,
            status: status,
            success: false
        }, status: status
    end

    def render_success(payload:, status: :ok)
        render json: {
            success: true,
            payload: payload
        }, status: status
    end
    
end