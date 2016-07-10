module API
  module V1
    class Categories < Grape::API
      include API::V1::Defaults

      resource :categories do
        desc "Get all categories"
        get { return Category.all }

        desc "Create a new category"
        params do
          requires :category, type: Hash do
            requires :title, type: String, desc: "Category title"
            requires :icon, type: String, desc: "Category icon"
            requires :user_id, type: Integer, desc: "Creator ID"
          end
        end

        post do
          params = permitted_params["category"]
          current_user.categories.create!(title: params["title"], icon: params["icon"])
        end

        route_param :id do
          params do
            requires :id, type: Integer
            requires :category, type: Hash do
              requires :title, type: String, desc: "Category title"
              requires :icon, type: String, desc: "Category icon"
            end
          end

          put do
            params = permitted_params[:category]
            category = Category.find(permitted_params[:id])
            authorize category, :update?
            category.update!(title: params[:title], icon: params[:icon])
          end

          params do
            requires :id, type: Integer
          end

          delete do
            category = Category.find(permitted_params["id"])
            authorize category, :destroy?
            category.destroy!
            nil
          end
        end
      end
    end
  end
end
