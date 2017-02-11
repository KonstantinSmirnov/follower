FactoryGirl.define do

  factory :webpage_with_script, class: Webpage do
    url 'http://localhost:3000/test_widget/with_script'
  end

  factory :webpage_without_script, class: Webpage do
    url 'http://localhost:3000/test_widget/without_script'
  end

end
