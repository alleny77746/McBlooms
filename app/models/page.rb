class Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :title, type: String
  field :content, type: String
  field :start_on, type: Date
  field :end_on, type: Date

  attr_accessor :menu_type

  validates :title, presence: true
  validates :content, presence: true

  slug :title

  has_many :menus, dependent: :destroy

  after_save :build_menu

  #######
  private
  #######
  
  def build_menu
    if menu_type.present?
      Menu.create(title: title, type: menu_type, page_id: id)
    end
  end
end
