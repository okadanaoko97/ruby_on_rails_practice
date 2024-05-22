class StaffEvent < ApplicationRecord
  self.inheritance_column = nil  #typeカラムから特別な意味が失われる

  belongs_to :member, class_name: "StaffMember", foreign_key: "staff_member_id"
  alias_attribute :occurred_at, :created_at
  #alias_attributeは指定した属性名（この場合はcreated_at）に別名（occurred_at）をつけるメソッドです。
  #これにより、created_atという名前で保存されているデータに対して、occurred_atという名前でもアクセスできるようになります。

  DESCRIPTIONS = {
    logged_in: "ログイン",
    logged_out: "ログアウト",
    rejected: "ログイン拒否"
  }

  def description
    DESCRIPTIONS[type.to_sym]
  end
end
