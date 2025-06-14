resource "aws_eip" "this" {
  domain = "vpc"
}

output "allocation_id" {
  value = aws_eip.this.id
}

