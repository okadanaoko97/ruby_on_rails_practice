class Customer < ApplicationRecord
  include EmailHolder
  include PersonalNameHolder
  include PasswordHolder

  has_many :addresses, dependent: :destroy        #検索する時のみ使用、autosaveオプション不要
  has_one :home_address, autosave: true
  has_one :work_address, autosave: true
  has_many :phones, dependent: :destroy
  has_many :personal_phones, -> { where(address_id: nil).order(:id) },
    class_name: "Phone", autosave: true
  has_many :entries, dependent: :destroy
  has_many :programs, through: :entries, source: :programs
  has_many :messages
  has_many :outbound_messages, class_name: "CustomerMessage",       #顧客が送信したメッセージ（問い合わせ、返信の返信）
    foreign_key: "customer_id"
  has_many :inbound_messages, class_name: "StaffMessage",           #顧客が職員から受け取ったメッセージ（返信）
    foreign_key: "customer_id"

  validates :gender, inclusion: { in: %w(male female), allow_blank: true }
  validates :birthday, date: {
    after: Date.new(1900, 1, 1),
    before: ->(obj) { Date.today },
    allow_blank: true
  }

  before_save do
    if birthday
      self.birth_year = birthday.year
      self.birth_month = birthday.month
      self.birth_mday = birthday.mday
    end
  end
end
