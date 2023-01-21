// Create EC2 Instance Security Group

resource "aws_security_group" "instance_sg" {
    name        = "${var.app_name}-${var.environment}-sg"
    description = "Security group for nessus resources"
    vpc_id      = aws_vpc.main.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-sg"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

resource "aws_security_group_rule" "open_ssh" {
  cidr_blocks       = ["0.0.0.0/0"] // Harden to specific IP | This option is not recommended to leave on
  description       = "Allow all ssh traffic"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
}

# VPC Peer 1 security group rules

resource "aws_security_group_rule" "peer1_ingress" {
  cidr_blocks       = ["10.10.0.0/16"]
  description       = "Allow IPv4 traffic from accepter vpc 1"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp" # Allows ONLY ICMP traffic for testing
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
}

# VPC Peer 2 security group rules

resource "aws_security_group_rule" "peer2_ingress" {
  cidr_blocks       = ["10.132.20.0/22"]
  description       = "Allow IPv4 traffic from accepter vpc 2"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp" # Allows ONLY ICMP traffic for testing
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
}

# VPC Peer 3 security group rules

resource "aws_security_group_rule" "peer3_ingress" {
  cidr_blocks       = ["10.207.0.0/22"]
  description       = "Allow IPv4 traffic from accepter vpc 3"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp" # Allows ONLY ICMP traffic for testing
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
}

// Temporary - Will delete after testing vpn connection

resource "aws_security_group_rule" "icmp_all_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow all IPv4 traffic from any source IPv4 address"
  from_port         = -1
  to_port           = -1
  protocol          = "icmp" # Allows ONLY ICMP traffic for testing
  type              = "ingress"
  security_group_id = aws_security_group.instance_sg.id
}