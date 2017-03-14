require 'rails_helper'

RSpec.describe Webpage, type: :model do
  it 'has a valid factory [page with script]' do
    webpage = FactoryGirl.create(:webpage_with_script)

    expect(webpage).to be_valid
  end

  it 'has a valid factory [page without script]' do
    webpage = FactoryGirl.create(:webpage_without_script)

    expect(webpage).to be_valid
  end

  it "is invalid without url" do
    webpage = FactoryGirl.build(:webpage, url: '')

    expect(webpage).not_to be_valid
    expect(webpage.errors[:url]).to include("can't be blank")
  end

  it "is invalid without name" do
    webpage = FactoryGirl.build(:webpage, name: '')

    expect(webpage).not_to be_valid
    expect(webpage.errors[:name]).to include("can't be blank")
  end

  it "is valid with correct data" do
    webpage = Webpage.create(
      url: 'http://mail.ru',
      name: 'Test webpage'
    )

    expect(webpage).to be_valid
  end

  it "belongs to a user" do
    user = FactoryGirl.create(:user)
    webpage = FactoryGirl.create(:webpage, user: user)

    expect(webpage).to be_valid
    expect(webpage.user).to eq(user)
  end
end
