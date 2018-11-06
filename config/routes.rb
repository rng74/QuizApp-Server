Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/get_hundred", to: "req#send_it"
    end
  end
end
