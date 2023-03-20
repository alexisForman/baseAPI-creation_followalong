module Api
    module V1
        class UsersController < Api::V1::ApplicationController
            skip_before_action :authenticate, only: [:create, :login]

            def create
                # 1. Get the result from the service
                result = BaseApi::Users.new_user(params)
                # 2. Return an error if result was unsuccessful.
                render_error(errors: "There was a problem creating your user account.", status: 400) and return unless result.success?
                # 3. Build a payload.
                payload = {
                    user: UserBlueprint.render_as_hash(result.payload, view: :normal)
                }
                # 4. Return a successful response attached with the payload.
                render_success(payload: payload, status: 201)
                
                
                # if user.save
                #     # This is the original code, we refactored it to application_controller.
                #     # render json: { success: true, user: UserBlueprint.render_as_hash(user, view: :normal), status: 201 }
                #     render_success(payload: { user: UserBlueprint.render_as_hash(user, view: :normal) }, 
                #                     status: :created)
                # else
                #     # This is the original code, we refactored it to application_controller.
                #     # render json: { errors: "There was a problem creating a new user.", status: 400 }
                #     render_error(errors: "There was a problem creating your user account.", status: 400)
                # end
            end

            def login
                result = BaseApi::Auth.login(params[:email], params[:password], @ip)
                render_error(errors: "You are not authenticated.", status: 401) and return unless result.success?
                payload = {
                    user: UserBlueprint.render_as_hash(result.payload[:user], view: :login),
                    token: TokenBlueprint.render_as_hash(result.payload[:token]), 
                    status: 200
                }
                render_success(payload: payload, status: 201)
            end

            def me
                render_success(payload: UserBlueprint.render_as_hash(@current_user), status: 200)
            
            end

            def logout
                result = BaseApi::Auth.logout(@current_user, @token)
                render_error(errors: "There was an issue logging you out.", status: 401) and return unless result.success?

                render_success(payload: "You have been logged out.", status: 200)
            end
        end
    end
end