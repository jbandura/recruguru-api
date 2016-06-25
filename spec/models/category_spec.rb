RSpec.describe Category do
  it { is_expected.to have_attribute :title }
  it { is_expected.to have_attribute :icon }

  it { is_expected.to belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :icon }
end
