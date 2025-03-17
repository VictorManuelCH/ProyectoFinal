class User < ApplicationRecord
  after_create :create_cart
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :user_role
  has_many :roles, through: :user_role
  has_many :user_addresses

  after_create :create_cart

  def administrador?
    roles.exists?(name: 'Administrador') # Asegúrate de que 'Administrador' sea el nombre correcto del rol
  end

  def create_cart
    Cart.create(user: self)
  end
end
