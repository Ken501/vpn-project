// Create VPC

resource "aws_vpc" "main" {
  cidr_block = "${var.environment == "prod" ? "${local.vpc_cidr[0]}" : "${local.dev_vpc_cidr[0]}"}"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-vpc"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Create and attach Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-gw"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Default route table

resource "aws_default_route_table" "default_table" {
 default_route_table_id = aws_vpc.main.default_route_table_id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }
    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-default-table"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "${var.environment == "prod" ? "${local.public[0]}" : "${local.dev_public[0]}"}"
  availability_zone       = local.az[0]
  map_public_ip_on_launch = true

    tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-public"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Default Security Group

resource "aws_default_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
      protocol  = -1
      self      = true
      from_port = 0
      to_port   = 0
  }

  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

      tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-default-sg"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Create route table and associations
// Public route table

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.gw.id
  }

  route { # Peer 1 route
      cidr_block                = "10.10.0.0/16"
      vpc_peering_connection_id = aws_vpc_peering_connection.peer1_connection.id
  }

    route { # Peer 2 route
      cidr_block                = "10.132.20.0/22"
      vpc_peering_connection_id = aws_vpc_peering_connection.peer2_connection.id
  }

      route { # Peer 3 route
      cidr_block                = "10.207.0.0/22"
      vpc_peering_connection_id = aws_vpc_peering_connection.peer3_connection.id
  }
        tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-public-route"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

// Table association

resource "aws_route_table_association" "public_association" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public_route.id
}