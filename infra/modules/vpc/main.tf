// The VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-vpc-main"
    }
  )
}

// Only one availability zone
data "aws_availability_zone" "zone" {
  name = "${var.region}a"
}

// API data ingestion
resource "aws_subnet" "ingest" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = data.aws_availability_zone.zone.name_suffix

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-ingest"
    }
  )
}

// The 'lake'
resource "aws_subnet" "lake" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = data.aws_availability_zone.main_zone.name_suffix

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-lake"
    }
  )
}

// Trusted Research Environment (TRE)
resource "aws_subnet" "tre" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = data.aws_availability_zone.main_zone.name_suffix

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-tre"
    }
  )
}

// VPN for data lake
resource "aws_subnet" "lake_vpn" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.0.4.0/24"
}
