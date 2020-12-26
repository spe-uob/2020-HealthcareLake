/* 
  Network Access Control List (ACL) rules
  the `lake` can access the `ingest` and `tre` subnets,
  but the `ingest` and `tre` subnets can't access the `lake`
  this is for security reasons,
*/

resource "aws_network_acl" "lake" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.lake}"]

  // allow vpn
  ingress {
    rule_no = 100
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake_vpn.cidr_block}"
  }
  egress {
    rule_no = 110
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake_vpn.cidr_block}"
  }

  // deny all inbound
  ingress {
    rule_no = 120
    action = "deny"
    protocol = "all"
  }
  // deny all outbound
  egress {
    rule_no = 130
    action = "deny"
    protocol = "all"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-lake_acl"
    }
  )
}

resource "aws_network_acl" "tre" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.tre}"]

  // allow lake to access tre
  ingress {
    rule_no = 140
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake.cidr_block}"
  }
  egress {
    rule_no = 150
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake.cidr_block}"
  }
  // deny all other inbound access
  ingress {
    rule_no = 160
    action = "deny"
    protocol = "all"
  }
  // deny all outbound
  egress {
    rule_no = 170
    action = "deny"
    protocol = "all"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-tre_acl"
    }
  )
}

resource "aws_network_acl" "ingest" {
  vpc_id = "${aws_vpc.main.id}"
  subnet_ids = ["${aws_subnet.ingest.id}"]

  // allow lake access to ingest data
  ingress {
    rule_no = 180
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake.cidr_block}"
  }
  egress {
    rule_no = 190
    action = "allow"
    protocol = "all"
    cidr_block = "${aws_subnet.lake.cidr_block}"
  }
  // deny all other inbound access
  ingress {
    rule_no = 200
    action = "deny"
    protocol = "all"
  }
  // deny all outbound
  egress {
    rule_no = 210
    action = "deny"
    protocol = "all"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}-ingest_acl"
    }
  )
}