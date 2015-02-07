class Video < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :queue_items
  has_many :reviews

  validates_presence_of :title, :description

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
      sum = reviews.to_a.sum(&:rating).to_f
      sum / count
    end
  end

  def self.order_by_created_at
    self.order("created_at DESC")
  end
end
