module SessionsHelper
    def log_in(user)
        session[:user_id] = user.id
    end

    def current_user
        if session[:user_id]
            User.find_by(id: session[:user_id])
        end
    end

    def logged_in?
        !current_user.nil?
    end

    # 永続的セッションを破棄する
    def forget(user)
        cookies.delete(:user_id)
    end

    # 現在のユーザーをログアウトする
    def log_out
        forget(current_user)
        session.delete(:user_id)
        @current_user = nil
    end
end
