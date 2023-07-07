class Task < ApplicationRecord
  validates :title, presence:true
  validates :content, presence:true
  validates :deadline, presence: true
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  scope :title_like, ->(title){where('title LIKE?',"%#{title}%") if title.present?}
  scope :status_is, ->(status){where(status: status)if status.present?}
  enum priority: { high: 0, medium: 1, low: 2 }
  belongs_to :user
end
