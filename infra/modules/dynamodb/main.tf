resource "aws_dynamodb_table" "entities" {
  name         = "revops-entities-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"
  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }
  server_side_encryption { enabled = true }
}
variable "env" { type = string }
