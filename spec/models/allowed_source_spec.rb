require "rails_helper"

RSpec.describe AllowedSource, type: :model do
  describe "#ip_address=" do
    example "引数に「127.0.0.1」を与えた場合" do
      src = AllowedSource.new(namespace: "staff", ip_address: "127.0.0.1")
      expect(src.octet1).to eq(127)
      expect(src.octet2).to eq(0)
      expect(src.octet3).to eq(0)
      expect(src.octet4).to eq(1)
      expect(src).not_to be_wildcard
      expect(src).to be_valid
    end

    example "引数に「192.168.0.*」を与えた場合" do
      src = AllowedSource.new(namespace: "staff", ip_address: "192.168.0.*")
      expect(src.octet1).to eq(192)
      expect(src.octet2).to eq(168)
      expect(src.octet3).to eq(0)
      expect(src.octet4).to eq(0)
      expect(src).to be_wildcard
      expect(src).to be_valid
    end

    example "引数に不正な⽂字列を与えた場合" do
      src = AllowedSource.new(namespace: "staff", ip_address: "A.B.C.D")
      expect(src).not_to be_valid
    end
  end

  describe ".include?" do
    before do
      Rails.application.config.baukis2[:restrict_ip_addresses] = true
      AllowedSource.create!(namespace: "staff", ip_address: "127.0.0.1")
      AllowedSource.create!(namespace: "staff", ip_address: "192.168.0.*")
    end

    example "マッチしない場合" do
      expect(AllowedSource.include?("staff", "192.168.1.1")).to be_falsey
    end

    example "全オクテットがマッチする場合" do
      expect(AllowedSource.include?("staff", "127.0.0.1")).to be_truthy
    end

    example "*付きのAllowedSourceにマッチする場合" do
      expect(AllowedSource.include?("staff", "192.168.0.100")).to be_truthy
    end
  end
end

# "192.168.0." というワイルドカードを含むエントリにマッチするかを確認します。
# "192.168.0." は 192.168.0.0 から 192.168.0.255 までのアドレスにマッチするので、"192.168.0.100" もこれに該当し、結果は true（truthy）です。
# octet4 の値が具体的に何であるかは関係なく、最初の3オクテット (192.168.0) が一致しており、ワイルドカード (*) が有効になっているためです。
