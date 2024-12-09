terraform {
  backend "s3" {
    region         = "ap-southeast-2"
    bucket         = "crc-state-file"
    key            = "backend.terraform.tfstate"
    dynamodb_table = "crc-backend-state-lock-01"
    encrypt        = true
  }
}