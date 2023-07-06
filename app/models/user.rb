class User < ApplicationRecord
  before_destroy :at_least_one_admin_destroy
  before_update :at_least_one_admin_update
  
  validates :name,  presence:true, length: { maximum: 30 }
  validates :email, presence:true, length: { maximum: 255 },
                                   format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  before_validation { email.downcase! }
  has_many :tasks, dependent: :destroy

  enum role: { general: 0, admin: 1 }

  def at_least_one_admin_destroy
    if User.where(role: :admin).count <= 1 && admin?
      errors.add(:base, "最後の一人の管理者は削除できません")
      throw :abort
    end
  end

  def at_least_one_admin_update
    if User.where(role: :admin).count <= 1 && admin? && !admin_was
      errors.add(:base, "管理者を1人以上維持してください")
      throw :abort
    end
  end
end
