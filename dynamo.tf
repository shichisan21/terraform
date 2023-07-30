resource "aws_dynamodb_table" "for-talk-app" {
  name           = "talk-app-table"  # テーブル名を指定します
  hash_key       = "Id"  # ハッシュキー（パーティションキー）を指定します
  billing_mode   = "PROVISIONED"
  read_capacity  = 20  # 読み取り容量ユニットを指定します
  write_capacity = 20  # 書き込み容量ユニットを指定します

  attribute {
    name = "Id"
    type = "S"  # 'S' stands for String. This was 'N' (Number) previously.
  }
}
