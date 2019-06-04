Rails.application.routes.draw do
  
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: 'users/sessions'}

  
  namespace :api do

    #Kiosk API
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
    post "/kiosk/process_events", to:"kiosk#process_events"
    get "/kiosk/qr_signin", to:"kiosk#validate_QR"
    post "/kiosk/process_qr_events", to:"kiosk#process_qr_events"
    get "/kiosk/signout", to:"kiosk#signout"
    post "/kiosk/forgot_pin", to:"kiosk#forgot_pin"

    #mobile API
    post "/mobile/sign_in", to:"mobile#signin"
    post "/mobile/forgot_pin", to:"mobile#forgot_pin"
    post "/mobile/reset_pin", to:"mobile#reset_pin"
    post "/mobile/set_personal_details", to:"mobile#set_personal_details"
    get "/mobile/my_customers", to:"mobile#get_visitor_companies"
    get "/mobile/my_visits", to:"mobile#get_visits"
    get "/mobile/agreements", to:"mobile#get_agreements"
    get "/mobile/departments", to:"mobile#get_departments"
    get "/mobile/notes", to:"mobile#get_notes"
    post "/mobile/update_notes", to:"mobile#update_notes"
    post "/mobile/new_visit", to:"mobile#process_events"

  end


  root to: 'dashboard#index'
end
