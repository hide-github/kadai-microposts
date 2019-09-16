class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50}
  validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                                    uniqueness: { case_sensitive: false }
  
  has_secure_password
  
  has_many :microposts
  
  #中間テーブル_relationships
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  #中間テーブル_favorites
  has_many :favorites
  has_many :favorite_microposts, through: :favorites, source: :micropost
  
  #relationshipsテーブルを通したフォロー、アンフォロー、フォロー一覧
  def follow(other_user)
    unless self == other_user
     self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
  
  def following?(other_user)
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  #favoritesテーブルを通したlike、unlike
  
  def favorite(micropost)
    if self.id != micropost.user_id
    self.favorites.find_or_create_by(micropost_id: micropost.id)
    end
  end
  
  def unfavorite(micropost)
    favorite = self.favorites.find_by(micropost_id: micropost.id)
    favorite.destroy if favorite
  end
  
  def liking?(micropost)
    self.favorite_microposts.include?(micropost)
  end

  def feed_favorites
    Micropost.where(user_id: self.favorite_micropost_ids + [self.id])
  end
  
end
