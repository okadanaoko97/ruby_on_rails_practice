class Phone < ApplicationRecord
  include StringNormalizer

  belongs_to :customer, optional: true   #関連するカスタマーが存在しなくてもよい
  belongs_to :address, optional: true

  before_validation do
    self.number = normalize_as_phone_number(number)
    self.number_for_index = number.gsub(/\D/, "") if number    #/\D/: 数字以外のすべての文字にマッチします。\Dは[^0-9]と同等
  end

  before_create do
    self.customer = address.customer if address             #Phoneインスタンスのcustomer属性を、関連するaddressオブジェクトのcustomer属性で更新する
  end

  validates :number, presence: true,
    format:  { with: /\A\+?\d+(-\d+)*\z/, allow_blank: true }
end

# \A: 文字列の開始を意味します。これにより、検証が文字列の最初から始まることが保証されます。
# \+?: プラス記号 (+) が0回または1回出現することを許可します。これは主に国際電話番号の形式で使用される記号です。
# \d+: 一つ以上の数字が続くことを要求します。ここで \d は数字を表すメタ文字です。
# (-\d+)*: ハイフン (-) で始まり、その後に一つ以上の数字が続くパターンを0回以上繰り返すことができます。これにより、ハイフンで区切られた電話番号形式を許容します。
# \z: 文字列の終了を意味します。
