RSpec.describe CategoryPolicy do
  let(:user) { User.new }

  subject { described_class }

  permissions :update?, :destroy? do
    context "as user" do
      let(:user) { User.new(id: 1, role: :user) }
      it "denies access if user is not owner" do
        expect(subject).not_to permit(user, Category.new(user_id: 3))
      end
      it "allows access if user owns the resource" do
        expect(subject).to permit(user, Category.new(user_id: 1))
      end
    end

    context "as admin" do
      let(:user) { User.new(id: 1, role: :admin) }
      it "allows access if user is admin" do
        expect(subject).to permit(User.new(id: 1, role: :admin), Category.new(user_id: 3))
      end
    end
  end
end
