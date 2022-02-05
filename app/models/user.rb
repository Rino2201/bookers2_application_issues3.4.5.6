class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books,dependent: :destroy
  has_many :book_comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

# ------------------------------------------------------------------------
  # フォローする、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  #以下サンプルコード
  # # 自分がフォローされる（被フォロー）側の関係性
  # has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # # 被フォロー関係を通じて参照→自分をフォローしている人
  # has_many :followers, through: :reverse_of_relationships, source: :follower

  # # 自分がフォローする（与フォロー）側の関係性
  # has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # # 与フォロー関係を通じて参照→自分がフォローしている人
  # has_many :followings, through: :relationships, source: :followed
# ------------------------------------------------------------------------

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
 # ------------------------------------------------------------------------
  #フォローした時の処理
  def follow(user)
    relationships.create(followed_id: user.id)
  end

  #フォローを外す時の処理
  def unfollow(user)
    relationships.find_by(followed_id: user.id).destroy
  end

  #フォローしているか判定
  def following?(user)
    followings.include?(user)
  end
# ------------------------------------------------------------------------
  def self.search_for(content, method)
    if method == 'perfect'
      User.where(name: content)
    elsif method == 'forward'
      User.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      User.where('title LIKE ?','%'+content)
    else
      User.where('title LIKE ?','%'+content+'%')
    end
  end
# ------------------------------------------------------------------------

end
