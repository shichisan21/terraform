resource "aws_ses_email_identity" "otp_sender" {
  email = var.sender_email
}