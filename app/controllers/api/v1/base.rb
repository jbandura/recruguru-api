module API
  module V1
    class Base < Grape::API
      helpers API::AuthHelpers
      mount API::V1::Sessions
    end
  end
end
