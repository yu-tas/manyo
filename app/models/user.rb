class User < ApplicationRecord
  before_destroy :at_least_one_admin
  before_update :at_least_one_admin
  
  validates :name,  presence:true, length: { maximum: 30 }
  validates :email, presence:true, length: { maximum: 255 },
                                   format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  before_validation { email.downcase! }
  has_many :tasks, dependent: :destroy

  def at_least_one_admin
    if User.where(admin: true).count <= 1 && self.admin?
      errors.add(:base, "最後の一人の管理者は削除できません")
      throw :abort
    end
  end
end
