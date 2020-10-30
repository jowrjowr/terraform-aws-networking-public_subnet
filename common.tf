# configure the availability zones in the abstract

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_length = length(data.aws_availability_zones.available.names)
  az_names  = data.aws_availability_zones.available.names
  zone_ids  = toset(data.aws_availability_zones.available.zone_ids)
  az_number = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
  }
}

data "aws_availability_zone" "names" {
  for_each = local.zone_ids
  zone_id  = each.key
}
