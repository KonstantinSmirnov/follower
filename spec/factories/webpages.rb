FactoryGirl.define do

  factory :webpage_with_script, class: Webpage do
    url 'http://localhost:3000/test_widget/with_script'
    name 'Webpage with script'
  end

  factory :another_webpage_with_script, class: Webpage do
    url 'http://localhost:3000/test_widget/another_with_script'
    name 'Another webpage with script'
  end

  factory :webpage_without_script, class: Webpage do
    url 'http://localhost:3000/test_widget/without_script'
    name 'Webpage without script'
  end

  factory :webpage do
    url 'http://mail.ru'
    name 'Webpage'
  end

end
