
# no reason to have traffic going out to the internet anyway, and this
# makes it easier to do IAM policy.

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3_internal" {
  vpc_id       = var.vpc_id
  service_name = data.aws_vpc_endpoint_service.s3.service_name
  tags = {
    Name        = "${var.name} public"
    terraform   = "true"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_vpc_endpoint_route_table_association" "s3_internal" {
  for_each        = local.zone_ids
  vpc_endpoint_id = aws_vpc_endpoint.s3_internal.id
  route_table_id  = aws_route_table.public[each.key].id
}

# because outbound internet broke a little bit, and this is good policy in general.

data "aws_vpc_endpoint_service" "dynamodb" {
  service = "dynamodb"
}

resource "aws_vpc_endpoint" "dynamodb_internal" {
  vpc_id       = var.vpc_id
  service_name = data.aws_vpc_endpoint_service.dynamodb.service_name
  tags = {
    Name        = "${var.name} public"
    terraform   = "true"
    project     = var.project
    environment = var.environment
  }
}

resource "aws_vpc_endpoint_route_table_association" "dynamodb_internal" {
  for_each        = local.zone_ids
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_internal.id
  route_table_id  = aws_route_table.public[each.key].id
}
