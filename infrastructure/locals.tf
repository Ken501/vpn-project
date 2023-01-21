// Define local variables

locals {
    dev_vpc_cidr  = ["10.68.0.0/16"]
    vpc_cidr       = ["10.69.0.0/16"]
    dev_public    = ["10.68.0.0/20"]
    public         = ["10.69.0.0/20"]
    public_id      = [aws_subnet.public.id]
    az             = ["us-east-1a"]
}