variable "env" { type = string }
variable "table_name" { type = string default = "revops-entities" }

resource "aws_dynamodb_table" "entities" {
  name         = "${var.table_name}-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"
  attribute { name = "pk" type = "S" }
  attribute { name = "sk" type = "S" }
  server_side_encryption { enabled = true }
}

output "table_name" { value = aws_dynamodb_table.entities.name }
output "table_arn" { value = aws_dynamodb_table.entities.arn }
