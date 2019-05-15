RailsAdmin.config do |config|
  config.parent_controller = '::ApplicationController'
  
  config.authorize_with do
    redirect_to main_app.root_path unless %w{admin super_admin}.include?(current_user.role)
  end

  config.main_app_name = ["Indushield", "Admin"]

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  #config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard do
      statistics false
    end
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end

def do_name_search(params, searched_model_name)
  first_name = params[:query].split(" ").first
  last_name = params[:query].split(" ").last
  p "do_name_search() Look for first name:#{first_name} and last name:#{last_name}"
  searched_class = searched_model_name.titleize.gsub(/ /,'').constantize
  filtered = searched_class.where("CONCAT(TRIM(first_name), ' ', TRIM(last_name)) ILIKE :search", search: "%#{params[:query]}%")
  params[:query] = "#{first_name} #{last_name}"
  filtered
end
