class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  enum status: { 未着手: 0, 着手中: 1, 完了: 2 }
  scope :title_like, ->(title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :status_is, ->(status) { where(status: status) if status.present? }
  scope :label_is, -> (label_ids) {joins(:labels).where(labels: { id: label_ids })}
  enum priority: { high: 0, medium: 1, low: 2 }
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
end

