Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    get 'authors', to: 'authors#index'
    get 'venues', to: 'venues#index'
    get 'publication_titles', to: 'publication_titles#index'

    resources :publications, only: [:show]

    # params: venue / author
    get 'num_publications_by_year', to: 'num_publications_by_year#index'

    # params: title / venue / author
    get 'num_citations_by_year', to: 'num_citations_by_year#index'

    # params: *top / venue / start_year / end_year
    get 'top_authors_by_num_publications', to: 'top_authors_by_num_publications#index'
    get 'top_publications_by_num_citations', to: 'top_publications_by_num_citations#index'

    # params: *title / *depth = 0
    get 'citation_network', to: 'citation_network#index'

    # params: author
    get 'word_cloud', to: 'word_cloud#index'
  end
end
