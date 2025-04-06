resource "aws_vpc" "tf_vpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "tf-vpc"
  }
}

resource "aws_subnet" "tf_pub_sub" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "tf-pub-sub"
  }
}

resource "aws_subnet" "tf_pvt_sub" {
  vpc_id     = aws_vpc.tf_vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "tf-pvt-sub"
  }
}

resource "aws_route_table" "tf_pub_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }
  tags = {
    Name = "tf-pub-rt"
  }
}

resource "aws_route_table" "tf_pvt_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_nat_gateway.tf_nat.id
  }
  tags = {
    Name = "tf-pvt-rt"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf-igw"
  }
}

resource "aws_eip" "tf_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "tf_nat" {
  allocation_id = aws_eip.tf_eip.id
  subnet_id     = aws_subnet.tf_pub_sub.id

  tags = {
    Name = "tf-NAT"
  }
}

resource "aws_route_table_association" "tf_pub_rta" {
  subnet_id = aws_subnet.tf_pub_sub.id
  route_table_id = aws_route_table.tf_pub_rt.id
}

resource "aws_route_table_association" "tf_pvt_rta" {
  subnet_id = aws_subnet.tf_pvt_sub.id
  route_table_id = aws_route_table.tf_pvt_rt.id
}