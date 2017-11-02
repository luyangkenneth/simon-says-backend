Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    get 'word_cloud', to: 'word_cloud#index'
  end
end
