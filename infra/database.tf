# Create a DynamoDB table for vistor counter
resource "aws_dynamodb_table" "visitor_counter" {
  name         = "visitor_counter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  range_key    = "count"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "count"
    type = "S"
  }
}

# Monitor state locking
resource "aws_dynamodb_table" "crc_backend_state_lock" {
  name           = "crc-backend-state-lock-01"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}