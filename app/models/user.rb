class User < ApplicationRecord
  
  #has_and_belongs_to_many :companies
  #has_and_belongs_to_many :roles
  
  enum role: [:user, :community, :admin, :super_admin, :community_admin]

  after_create :set_default_role

  def set_default_role
    update_attribute :role, :user if role.nil?
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  


end
