data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_route_table" "public" {
  for_each = local.zone_ids

  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.name} public ${each.key}"
    az          = each.key
    terraform   = "true"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  for_each       = local.zone_ids
  subnet_id      = aws_subnet.az-public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route" "public_gateway_v4" {
  for_each               = local.zone_ids
  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc_igw.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "public_gateway_v6" {
  for_each                    = local.zone_ids
  route_table_id              = aws_route_table.public[each.key].id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.vpc_igw.id
  depends_on                  = [aws_route_table.public]
}

resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = var.vpc_id
  tags = {
    Name        = "${var.name} internet gateway"
    terraform   = "true"
    environment = var.environment
    project     = var.project
  }
}

resource "aws_subnet" "az-public" {
  for_each                        = local.zone_ids
  availability_zone_id            = each.key
  vpc_id                          = var.vpc_id
  assign_ipv6_address_on_creation = true
  cidr_block                      = cidrsubnet(data.aws_vpc.vpc.cidr_block, 8, local.az_number[data.aws_availability_zone.names[each.key].name_suffix])
  ipv6_cidr_block                 = cidrsubnet(data.aws_vpc.vpc.ipv6_cidr_block, 8, local.az_number[data.aws_availability_zone.names[each.key].name_suffix])

  tags = {
    Name        = "${var.name} public ${each.key}"
    terraform   = "true"
    az          = each.key
    project     = var.project
    environment = var.environment
  }
}
