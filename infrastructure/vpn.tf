// Create VPN Gateway

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.main.id

        tags = merge(
      var.additional_tags,
      {
          Name          = "${var.app_name}-${var.environment}-vpc-gw"
          "Environment" = "${var.environment}"
          "Region"      = "${var.AWS_REGION}"
      },
  )
}

resource "aws_vpn_gateway_route_propagation" "public_route_propogation" {
  vpn_gateway_id = aws_vpn_gateway.vpn_gw.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = var.bgp_asn
  ip_address = var.customer_gateway_ip
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = "${aws_vpn_gateway.vpn_gw.id}"
  customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
  type                = "ipsec.1"
  static_routes_only  = true
}

// Static VPN Routes to local network

resource "aws_vpn_connection_route" "onpremise_cidr_1" {
  destination_cidr_block = var.cidr_route_1
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
}

resource "aws_vpn_connection_route" "onpremise_cidr_2" {
  destination_cidr_block = var.cidr_route_2
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
}

resource "aws_vpn_connection_route" "onpremise_cidr_3" {
  destination_cidr_block = var.cidr_route_3
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
}