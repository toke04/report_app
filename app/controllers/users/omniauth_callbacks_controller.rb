
# Deviseのコントローラーを継承することでDeviseのコントローラーと同じメソッド（つまりアクション）が使える
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # request.env["omniauth.auth"]にGitHubから送られてきたデータが入っている
    # binding.pryで確認してみましょう
    @user = User.find_for_github_oauth(request.env["omniauth.auth"])

    if @user.persisted? # データベースに保存されていればログイン成功
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Github") if is_navigational_format?
    else # ログイン失敗
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
