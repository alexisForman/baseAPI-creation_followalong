module BaseApi
    module Users
        def self.new_user(params)
            user = User.new(email: params[:email], first_name: params[:first_name], last_name: params[:last_name], phone: params[:phone], password: params[:password])

            begin
                user.save!
            rescue
                # Refactored into service_contract
                # return {success?:false} unless user.valid?
                return ServiceContract.error("Error saving message") unless user.valid?
            end
            # Refactored into service_contract
            # {success?: true, payload: user }
            ServiceContract.success(user)
        end
        # private
        # def userParams
        #     userParams = {email: params[:email], first_name: params[:first_name], last_name: params[:last_name], phone: params[:phone], password: params[:password]}
        # end
    end
end