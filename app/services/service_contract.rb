module ServiceContract
    def self.success(payload)
        OpenStruct.new({ success?: true, payload: payload, errors: nil })
    end

    def self.error(errors)
        OpenStruct.new({ success?: false, errors: errors, payload: nil })
    end
end