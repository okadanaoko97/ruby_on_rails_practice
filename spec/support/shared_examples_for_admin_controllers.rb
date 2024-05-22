shared_examples "a protected admin controller" do |controller|
  #未ログインの状態でこれらのアクションにアクセスした場合に、ログインページにリダイレクトするかどうかを確認

  let(:args) do
    {
      host: Rails.application.config.baukis2[:admin][:host],
      controller: controller
    }
  end

  describe "#index" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :index))
      expect(response).to redirect_to(admin_login_url)
    end
  end

  describe "#show" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :show, id: 1))
      expect(response).to redirect_to(admin_login_url)
    end
  end
end

shared_examples "a protected singular admin controller" do |controller|
  #特定のシングルリソースに関連する管理者コントローラ（例えばユーザープロファイルページなど、IDを必要としないページ）の#showアクションのアクセス制御をテスト
  let(:args) do
    {
      host: Rails.application.config.baukis2[:admin][:host],
      controller: controller
    }
  end

  describe "#show" do
    example "ログインフォームにリダイレクト" do
      get url_for(args.merge(action: :show))
      expect(response).to redirect_to(admin_login_url)
    end
  end
end
