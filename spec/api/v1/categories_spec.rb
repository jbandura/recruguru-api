RSpec.describe "API::V1::Sessions" do
  let(:resp) { JSON.parse(response.body) }
  let(:user) { create(:user) }
  before do
    Grape::Endpoint.before_each do |endpoint|
      allow(endpoint).to receive(:authenticated?).and_return(true)
      allow(endpoint).to receive(:current_user).and_return(user)
    end
  end

  describe "GET /api/v1/categories" do
    it "should fetch list of categories" do
      categories = create_list(:category, 3, user: user)
      get "/api/v1/categories"
      expect(response.status).to eq(200)
      expect(resp["categories"].length).to eq(categories.length)
    end
  end

  describe "POST /api/v1/categories" do
    let(:category_params) do
      {
        category: {
          title: "Test category",
          icon: "icon_1",
          user_id: user.id
        }
      }
    end

    subject { post "/api/v1/categories", category_params }

    it "should create a new category" do
      expect { subject }.to change { Category.count }.by(1)
      last_category = user.categories.last
      expect(last_category.title).to eq(category_params[:category][:title])
    end
  end

  describe "PUT /api/v1/categories/:id" do
    let(:new_params) do
      {
        category: { title: "New title", icon: "new_icon" }
      }
    end

    context "as an admin" do
      let(:user) { create(:user, role: :admin) }
      let(:category) { create(:category) }

      it "should update existing category" do
        put "/api/v1/categories/#{category.id}", new_params
        changed_category = Category.find(category.id)
        expect(changed_category.title).to eq(new_params[:category][:title])
        expect(changed_category.icon).to eq(new_params[:category][:icon])
      end
    end

    context "as an user" do
      let(:owner_user) { create(:user) }
      let(:category) { create(:category, user_id: owner_user.id) }

      it "should not allow editing of not owned categories" do
        put "/api/v1/categories/#{category.id}", new_params
        expect(response.status).to eq(401)
      end

      it "should allow editing of categories owned by user" do
        category = create(:category, user_id: user.id)
        put "/api/v1/categories/#{category.id}", new_params
        changed_category = Category.find(category.id)
        expect(changed_category.title).to eq(new_params[:category][:title])
        expect(changed_category.icon).to eq(new_params[:category][:icon])
      end
    end
  end

  describe "DELETE api/v1/categories/:id" do
    let(:owned_category) { create(:category, user_id: user.id) }
    let(:owner_user) { create(:user) }

    context "as an admin" do
      let(:user) { create(:user, role: :admin) }
      it "should allow deleting of not owned categories" do
        not_owned_category = create(:category, user_id: owner_user.id)
        categories_amount = Category.count
        delete "/api/v1/categories/#{not_owned_category.id}"
        expect(Category.count).to eq(categories_amount - 1)
      end
    end

    context "as an user" do
      it "should not allow deleting of not owned categories" do
        not_owned_category = create(:category, user_id: owner_user.id)
        delete "/api/v1/categories/#{not_owned_category.id}"
        expect(response.status).to eq(401)
      end

      it "should allow deleting of owned categories" do
        owned_category = create(:category, user_id: user.id)
        categories_amount = Category.count
        delete "/api/v1/categories/#{owned_category.id}"
        expect(Category.count).to eq(categories_amount - 1)
      end
    end
  end
end
