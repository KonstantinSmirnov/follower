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
end
