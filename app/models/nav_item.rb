class NavItem
  include ActiveModel::Model
  
  validates :name, presence: true
  validates :link, presence: true
  
end