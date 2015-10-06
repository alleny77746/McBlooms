Rails.application.routes.draw do

  resources :users do
    resources :reports
  end

  mount AnlekBootstrapHelper::Engine => "/anlek_bootstrap_helper"
end
