// Define local variables

locals {
    test_vpc_cidr  = ["10.68.0.0/16"] # IP block pending official confirmation from network admin
    vpc_cidr       = ["10.69.0.0/16"]
    test_public    = ["10.68.0.0/20"] # IP block pending official confirmation from network admin
    public         = ["10.69.0.0/20"]
    public_id      = [aws_subnet.public.id]
    az             = ["us-east-1a"]
}