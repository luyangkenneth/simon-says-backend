Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'main#index'

  namespace :api do
    # q1
    # /api/authors_by_num_publications?top=10&venue=arXiv
    get 'authors_by_num_publications', to: 'authors#index'

    # q2
    # /api/publications_by_num_citations?top=5&venue=arXiv
    get 'publications_by_num_citations', to: 'publications#index'

    # q3
    # /api/num_publications_by_year?venue=ICSE
    get 'num_publications_by_year', to: 'publications_trend#index'

    # q4
    # /api/citation_web?title=Low-density parity check codes over GF(q)
    get 'citation_web', to: 'citation_web#index'

    # q5
    # /api/word_cloud?venue=arXiv
    get 'word_cloud', to: 'word_cloud#index'
  end
end
