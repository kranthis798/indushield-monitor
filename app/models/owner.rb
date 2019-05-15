class Owner < ApplicationRecord
  include ResourceUtils
  belongs_to :us_state
  has_many :companies
  before_save :check_for_api_key

  rails_admin do
    edit do
      group :general_info do
        field :name
        field :api_key do
          label "API Key"
          visible {bindings[:view]._current_user.super_admin?}
          #css_class "admin-sugar-id"
          read_only true
        end
      end
      group :contact_info do
        active false
        field :phone
        field :address1
        field :address2
        field :us_state do
          label "US State"
        end
      end
      group :relationships do
        active false
        field :companies
      end
    end
  end

end
