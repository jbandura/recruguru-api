module API
  module V1
    class Sessions < Grape::API
      include API::V1::Defaults
      resource :sessions do
        get "" do
          return { name: "hello" }
        end
      end
    end
  end
end
