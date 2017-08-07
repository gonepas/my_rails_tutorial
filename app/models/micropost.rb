class Micropost < ApplicationRecord
  mount_uploader :picture, PictureUploader

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
   length: {maximum: Settings.micropost_max_length}
  validate :picture_size

  scope :order_desc, ->{order created_at: :desc}
  feed = lambda do |id|
    where "user_id IN (SELECT followed_id FROM relationships
      WHERE follower_id = #{id}) OR user_id = #{id}"
  end
  scope :feeds, feed

  private

  def picture_size
    return unless picture.size > Settings.pic_max_size
    errors.add :picture, t("error.pic_size")
  end
end
