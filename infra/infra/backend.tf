terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "crc-state-file"
    key            = "terraform.tfstate"
    dynamodb_table = "crc-infra-state-lock-01"
    encrypt        = true
  }
}