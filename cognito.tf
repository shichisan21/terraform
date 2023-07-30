resource "aws_cognito_user_pool" "mypool" {
  name = "sample_user_pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  username_attributes = ["email"]

  username_configuration {
    # ユーザー名(Email)で大文字小文字を区別しない。
    case_sensitive = true
  }

  # 今回はMFAを使用しないためOFF。
  mfa_configuration          = "OFF"


  # 「schema」は登録するユーザーに求める属性。(メールアドレスや電話番号など)
  # 「email」はデフォルトで有効になっている属性だが、今回は登録時に必須にしたいため設定。
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true

    string_attribute_constraints {
      min_length = 1
      max_length = 256
    }
  }

  # 「schema」は登録するユーザーに求める属性。(メールアドレスや電話番号など)
  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "age"
    required                 = false

    string_attribute_constraints {
      min_length = 1
      max_length = 3
    }
  }
  lambda_config {
    create_auth_challenge = aws_lambda_function.create_auth_challenge.arn
    define_auth_challenge = aws_lambda_function.define_auth_challenge.arn
    verify_auth_challenge_response = aws_lambda_function.verify_auth_challenge_response.arn
  }

  auto_verified_attributes = ["email"]
    tags = {
    Env = "dev"
  }
}


resource "aws_cognito_user_pool_client" "otp_client" {
  name            = "cognito_otp_client"
  user_pool_id    = aws_cognito_user_pool.mypool.id
  generate_secret = false
  allowed_oauth_flows = [
    "code",
    "implicit"
  ]
  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin"
  ]

    explicit_auth_flows = [
    # 更新トークン(新しいアクセストークンを取得するのに必要。)
    "ALLOW_REFRESH_TOKEN_AUTH",
    # SRPプロトコルを使用してユーザー名&パスワードを検証する。
    "ALLOW_USER_SRP_AUTH",
    # カスタム認証を許可する
    "ALLOW_CUSTOM_AUTH",
  ]
  prevent_user_existence_errors = "ENABLED"
  callback_urls = ["https://www.google.com"]
  default_redirect_uri = "https://www.google.com"
  logout_urls = ["https://www.yahoo.com"]
  allowed_oauth_flows_user_pool_client = true
}

resource "aws_cognito_user_pool_client" "client" {
  name            = "cognito_sample_client"
  user_pool_id    = aws_cognito_user_pool.mypool.id
  generate_secret = false
  allowed_oauth_flows = [
    "code",
    "implicit"
  ]
  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin"
  ]

    explicit_auth_flows = [
    # 更新トークン(新しいアクセストークンを取得するのに必要。)
    "ALLOW_REFRESH_TOKEN_AUTH",
    # SRPプロトコルを使用してユーザー名&パスワードを検証する。
    "ALLOW_USER_SRP_AUTH",
    # カスタム認証を許可する
    "ALLOW_CUSTOM_AUTH",
  ]
  prevent_user_existence_errors = "ENABLED"
  callback_urls = ["https://www.google.com"]
  default_redirect_uri = "https://www.google.com"
  logout_urls = ["https://www.yahoo.com"]
  allowed_oauth_flows_user_pool_client = true
}