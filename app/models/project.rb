class Project < ActiveRecord::Base
  attr_accessible :title

  has_many :memberships, {
    dependent: :destroy,
    inverse_of: :project
  }

  has_many :users, {
    through: :memberships
  }
end
