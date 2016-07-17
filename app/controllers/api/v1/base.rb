module API
  module V1
    class Base < Grape::API
      helpers API::AuthHelpers
      helpers Pundit
      mount API::V1::Sessions
      mount API::V1::Categories
      mount API::V1::Challenges
      mount API::V1::ChallengeVotes
    end
  end
end
