## ================================================
## Creating AWS Network Access control list section
## ================================================


resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id


  ingress {
    rule_no    = 120
    action     = "allow"
    cidr_block = var.all_cidr # Allow ingress from all sources
    protocol   = "tcp"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 130
    action     = "allow"
    cidr_block = var.all_cidr # Allow ingress from all sources
    protocol   = "tcp"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 500
    action     = "deny"
    cidr_block = var.all_cidr # Allow ingress from all sources
    protocol   = "icmp"
    from_port  = 0           # Note: These values might need to be adjusted based on your specific requirements
    to_port    = 0
  }



  egress {
    rule_no    = 210
    action     = "allow"
    cidr_block = var.all_cidr # Allow egress to all destinations
    protocol   = "-1"        # All protocols
    from_port  = 0           # Note: These values might need to be adjusted based on your specific requirements
    to_port    = 0
  }


  tags = {
    Name = "${var.tag}-nacl"
  }
}