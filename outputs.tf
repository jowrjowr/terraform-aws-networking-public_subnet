output "subnets" {
  description = "the list of public subnet ids"
  value       = [for az in local.zone_ids : aws_subnet.az-public[az].id]
}
