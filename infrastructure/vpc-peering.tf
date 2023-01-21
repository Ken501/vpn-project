// Create peering connection 1

resource "aws_vpc_peering_connection" "peer1_connection" {
  peer_owner_id = var.peer_id_1
  peer_vpc_id   = var.peer_vpc_id_1
  vpc_id        = aws_vpc.main.id
}

// Create peering connection 2

resource "aws_vpc_peering_connection" "peer2_connection" {
  peer_owner_id = var.peer_id_2
  peer_vpc_id   = var.peer_vpc_id_2
  vpc_id        = aws_vpc.main.id
}

// Create peering connection 3

resource "aws_vpc_peering_connection" "peer3_connection" {
  peer_owner_id = var.peer_id_3
  peer_vpc_id   = var.peer_vpc_id_3
  vpc_id        = aws_vpc.main.id
}