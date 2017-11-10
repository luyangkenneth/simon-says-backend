Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    get 'num_publications_by_year', to: 'num_publications_by_year#index'
    get 'num_citations_by_year', to: 'num_citations_by_year#index'
    get 'top_authors_by_num_publications', to: 'top_authors_by_num_publications#index'
  end
end
