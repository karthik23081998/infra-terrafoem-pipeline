resource "aws_vpc" "mynewvpc" {
    cidr_block = "172.16.0.0/16"
    tags = {
      Name ="vpcone"
    }
}
resource "aws_subnet" "musubnets" {
    vpc_id = aws_vpc.mynewvpc.id
    availability_zone = "ap-south-1a"
    cidr_block = "172.16.1.0/24"
    tags = {
        Name = "subnetskar"

    }

    }