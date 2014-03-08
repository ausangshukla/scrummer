Scummer::Application.routes.draw do
  resources :tasks do
    collection do
      get :task_board
    end
  end

  resources :sprints

  resources :features

  resources :project_user_mappings

  resources :projects

  as :user do
    match '/user/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end
  
  devise_for :users, :controllers => {:registrations => "registrations", :confirmations => "confirmations"}
  
  resources :users do
    collection do
      get :search
    end
  end
  
  root :to => "projects#index"
  mount ExceptionLogger::Engine => "/exception_logger"
  get '/:id' => 'pages#show', :as => :static

end
