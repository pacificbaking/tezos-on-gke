#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "pacificbaking" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-eks-worker-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
  )
}

resource "aws_subnet" "pacificbaking" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.pacificbaking.id

  tags = map(
    "Name", "terraform-eks-worker-node",
    "kubernetes.io/cluster/${var.cluster-name}", "shared",
    "kubernetes.io/role/elb", "1"
  )
}

resource "aws_internet_gateway" "pacificbaking" {
  vpc_id = aws_vpc.pacificbaking.id

  tags = {
    Name = "terraform-eks-pacificbaking"
  }
}

resource "aws_route_table" "pacificbaking" {
  vpc_id = aws_vpc.pacificbaking.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pacificbaking.id
  }
}

resource "aws_route_table_association" "pacificbaking" {
  count = 2

  subnet_id      = aws_subnet.pacificbaking.*.id[count.index]
  route_table_id = aws_route_table.pacificbaking.id
}
