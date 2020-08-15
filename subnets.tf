######################################################
# Public subnet
######################################################
resource "aws_subnet" "public" {
  count                   = 1
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index)}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "Public subnet - us-east-1a"
  }
}

######################################################
# Private subnet
######################################################
resource "aws_subnet" "private" {
  count  = 1
  vpc_id = "${aws_vpc.main.id}"

  # Take into account CIDR blocks allocated to the public subnets
  cidr_block              = "${cidrsubnet(var.cidr_block, 8, count.index + length(var.availability_zones))}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    "Name" = "Private subnet - us-east-1b"
  }
}

resource "aws_eip" "nat" {
  count = "1"
  vpc   = true
}

resource "aws_nat_gateway" "main" {
  count         = "1"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"

  tags = {
    "Name" = "NAT - ${element(var.availability_zones, count.index)}"
  }
}