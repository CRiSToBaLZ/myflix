class Video < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :queue_items
  has_many :reviews

  # default_scope { order("created_at DESC") }
  # scope :date_ordered, order("created_at DESC")

  # validates_presence_of :title, :description
  validates :title, presence: true
  validates :description, presence: true

  def self.search_by_title(search_term)
    if search_term.blank? #use blank instead of empty bc empty includes "  "
      return []
    else
      where("title LIKE ?", "%#{search_term}%").order_by_created_at
    end
  end

  def average_review
    if (count = self.reviews.count) == 0
      return "N/A"
    else
      # sum = 0
      # self.reviews.each do |review|
      #   sum += review.rating
      # end
      # sum = reviews.inject(0) { |sum, review| sum + review.rating }
      sum = reviews.to_a.sum(&:rating).to_f
      # sum / self.reviews.count
      # puts (sum / count)
      sum / count
    end
  end

  def self.order_by_created_at
    self.order("created_at DESC")
  end
end
