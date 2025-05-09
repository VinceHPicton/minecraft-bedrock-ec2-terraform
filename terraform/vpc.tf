resource "aws_vpc" "minecraft_vpc" {
  cidr_block = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
  tags = {
    Name = "minecraft-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.minecraft_vpc.id
  tags = {
    Name = "minecraft-igw"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.minecraft_vpc.id
  cidr_block              = "10.0.1.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.minecraft_vpc.ipv6_cidr_block, 8, 0)
  map_public_ip_on_launch = true
  assign_ipv6_address_on_creation = true
  availability_zone       = "eu-west-2a"
  tags = {
    Name = "public-subnet"
  }
}


resource "aws_route_table" "public_minecraft_rt" {
  vpc_id = aws_vpc.minecraft_vpc.id
  tags = {
    Name = "public-rt"
  }
}

# IPv4 route
resource "aws_route" "ipv4" {
  route_table_id         = aws_route_table.public_minecraft_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# IPv6 route
resource "aws_route" "ipv6" {
  route_table_id              = aws_route_table.public_minecraft_rt.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_minecraft_rt.id
}

output "vpc_id" {
  value = aws_vpc.minecraft_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}