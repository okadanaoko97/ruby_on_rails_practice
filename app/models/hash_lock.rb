class HashLock < ApplicationRecord
  class << self
    def acquire(table, column, value)
      HashLock.where(table: table, column: column,
        key: Digest::MD5.hexdigest(value)[0,2]).lock(true).first!
    end
  end
end

# Digest::MD5.hexdigest(value) は value のMD5ハッシュ値を計算し、その結果の最初の2文字を key として使用します
# true を指定することで、排他的ロック（書き込みロック）を取得し
# 検索結果の最初のレコードを取得します。レコードが見つからない場合は、ActiveRecord::RecordNotFound エラーを発生させます
