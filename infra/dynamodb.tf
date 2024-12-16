# Create a DynamoDB table for vistor counter
resource "aws_dynamodb_table" "visitor_counter" {
  name           = "visitor_counter"
  billing_mode   = "PROVISIONED"
  hash_key       = "id"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "id"
    type = "N"
  }

  attribute {
    name = "count"
    type = "N"
  }

  global_secondary_index {
    name            = "count-index"
    hash_key        = "count"
    projection_type = "ALL"
    write_capacity  = 1
    read_capacity   = 1
  }
}

# Initiate a predefined value
resource "aws_dynamodb_table_item" "table-items" {
  table_name = aws_dynamodb_table.visitor_counter.name
  hash_key   = aws_dynamodb_table.visitor_counter.hash_key


  item = <<ITEM
{
  "id" : { "N" : "1" },
  "count" : { "N" : "1" }
}
ITEM
}

output "encoded_item" {
  value = jsonencode({
    id    = { "N" : "1" },
    count = { "N" : "1" }
  })
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