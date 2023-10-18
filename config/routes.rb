Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "site#show"
  get "/*path", to: "site#show"
end
