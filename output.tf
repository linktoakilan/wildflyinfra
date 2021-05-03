output "vpc_id" {
    description = "ID of the VPC : "
    value = aws_vpc.example.id
  
}
output "vpc_name" {
    description = "Name of the VPC : "
    value = aws_vpc.example.tags.Name
  
}