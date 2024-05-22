class Customer::SessionsController < Customer::Base
  skip_before_action :authorize

  def new
    if current_customer
      redirect_to :customer_root
    else
      @form = Customer::LoginForm.new
      render action: "new"
    end
  end

  def create
    @form = Customer::LoginForm.new(login_form_params)
    if @form.email.present?
      customer =
        Customer.find_by("LOWER(email) = ?", @form.email.downcase)
    end
    if Customer::Authenticator.new(customer).authenticate(@form.password)
      if @form.remember_me?
        #cookies[:customer_id] = customer.id     クッキーに値をセット。ブラウザ側で閲覧可能かつ変更可能
        #cookies.signed[:customer_id] = customer.id     クッキーに値をブラウザ側で閲覧不可かつ変更不可
        cookies.permanent.signed[:customer_id] = customer.id        #クッキーの情報をブラウザ終了時に消滅させず、永続的に情報を残す
      else
        cookies.delete(:customer_id)
        session[:customer_id] = customer.id
      end
      flash.notice = "ログインしました。"
      redirect_to :customer_root
    else
      flash.now.alert = "メールアドレスまたはパスワードが正しくありません。"
      render action: "new"
    end
  end

  private def login_form_params
    params.require(:customer_login_form).permit(:email, :password, :remember_me)
  end

  def destroy
    cookies.delete(:customer_id)
    session.delete(:customer_id)
    flash.notice = "ログアウトしました。"
    redirect_to :customer_root
  end
end
