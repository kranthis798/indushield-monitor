Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: 'users/sessions'}

  #Kiosk API
  namespace :api do
    get "/kiosk/company", to:"kiosk#get_company_info"
    get "/kiosk/device", to:"kiosk#get_device_info"
    get "/kiosk/vendor_companies", to:"kiosk#get_vendor_companies"
    get "/kiosk/departments", to:"kiosk#get_departments"
    post "/kiosk/verify_phone", to:"kiosk#verify_phone"
    post "/kiosk/register_visitor", to:"kiosk#register_visitor"
    post "/kiosk/set_personal_details", to:"kiosk#set_personal_details"
    post "/kiosk/reset_pin", to:"kiosk#reset_pin"
    get "/kiosk/agreements", to:"kiosk#get_company_agreements"
    post "/kiosk/accept_agreements", to:"kiosk#accept_agreements"
    post "/kiosk/sign_in", to:"kiosk#signin"
  end

  root to: 'dashboard#index'
end
