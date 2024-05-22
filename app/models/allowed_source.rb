class AllowedSource < ApplicationRecord
  attr_accessor :last_octet, :_destroy

  before_validation do
    if last_octet
      self.last_octet.strip!
      if last_octet == "*"
        self.octet4 = 0
        self.wildcard = true
      else
        self.octet4 = last_octet
      end
    end
  end

  validates :octet1, :octet2, :octet3, :octet4, presence: true,
    numericality: { only_integer: true, allow_blank: true },      #整数の値のみ扱う
    inclusion: { in: 0..255, allow_blank: true }
  validates :octet4,
    uniqueness: {
      scope: [ :namespace, :octet1, :octet2, :octet3 ], allow_blank: true
    }
  validates :last_octet,
    inclusion: { in: (0..255).to_a.map(&:to_s) + [ "*" ], allow_blank: true }
    #配列の各要素に to_s メソッド（文字列に変換するメソッド）,数値の配列が文字列の配列に変換されます（例: [0, 1, 2, ..., 255] が ["0", "1", "2", ..., "255"] に変換されます）。


  after_validation do
    if last_octet
      errors[:octet4].each do |message|
        errors.add(:last_octet, message)
      end
    end
  end

  def ip_address=(ip_address)
    octets = ip_address.split(".")
    self.octet1 = octets[0]
    self.octet2 = octets[1]
    self.octet3 = octets[2]

    if octets[3] == "*"
      self.octet4 = 0
      self.wildcard = true
    else
      self.octet4 = octets[3]
    end
  end

  class << self
    def include?(namespace, ip_address)
      return true if !Rails.application.config.baukis2[:restrict_ip_addresses]
      #このコードの場合、:restrict_ip_addresses が false または設定されていない場合に true を返します。

      octets = ip_address.split(".")

      condition = %Q{
        octet1 = ? AND octet2 = ? AND octet3 = ?
        AND ((octet4 = ? AND wildcard = ?) OR wildcard = ?)
      }.gsub(/\s+/, " ").strip                             #/\s+/ は一つ以上の空白文字を表す正規表現で、一つ以上の空白文字（スペース、タブ、改行など）を単一のスペースに置換

      opts = [ condition, *octets, false, true ]           #=opts = [ condition, octets[0], octets[1], octets[2], octets[3], false, true ]
      where(namespace: namespace).where(opts).exists?
    end
  end
end

# IPアドレスの最初の3オクテットがデータベースに保存された値と一致し、
# 4オクテット目が特定の条件（ワイルドカードが true または false の場合の振る舞いを含む）と一致するかどうかを評価
