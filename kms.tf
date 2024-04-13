resource "aws_kms_key" "inter_kms_ec2_db" {
  description             = "KMS key for Database EC2 instances"
  deletion_window_in_days = 10
}
    