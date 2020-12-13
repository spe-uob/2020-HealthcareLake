/* 
  Gateways for the subnets

  - the `ingest` subnet has an Internet Gateway
  - the `lake` subnet has a Virtual Private Gateway
  
*/

resource "aws_internet_gateway" "ingest_gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-ingest_gw"
    }
  )
}

resource "aws_route_table" "ingest_public" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ingest_gw.id}"
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-ingest_public"
    }
  )
}

resource "aws_route_table_association" "ingest_public-a" {
  subnet_id = "${aws_subnet.ingest.id}"
  route_table_id = "${aws_route_table.ingest_public.id}"
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = data.aws_availability_zone.main_zone.name_suffix
  
  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-vpn_gw"
    }
  )
}
