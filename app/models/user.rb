class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  # uidとproviderカラムの組み合わせを一意にする
  validates :uid, presence: true, uniqueness: { scope: :provider }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  # authの中身はGitHubから送られてくる大きなハッシュ。この中に名前やメアドなどが入っている。
  # providerカラムとuidカラムが送られてきたデータと一致するユーザーを探す。
  # もしユーザーが見つからない場合は新規作成する。
  def self.find_for_github_oauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      # 名前を取得するときはこのように書く（今回はUserモデルにname属性がないのでエラーなる）
      user.name = auth.info.name
      user.image = auth.info.image
      user.email = auth.info.email
      # 任意の20文字の文字列を作成する
      user.password = Devise.friendly_token[0, 20]
    end
  end
  # 最後に使います。
  def self.create_unique_string
    SecureRandom.uuid
  end
end
