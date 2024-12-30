
## ========================
## Creating AWS VPC section
## ========================

resource "aws_vpc" "vpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.tag
  }
}

## =====================================
## Creating AWS internet gateway section
## =====================================
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

## ==================================
## Creating AWS Public subnet section
## ==================================
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
}

## ===================================
## Creating AWS Private subnet section
## ===================================
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)
}





## ================================
## Creating AWS route table section
## ================================
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
}
 
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.all_cidr
  gateway_id             = aws_internet_gateway.igw.id
}
 
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}


## =============================================
## Creating AWS Nat gateway and EasticIP section
## =============================================
resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.igw]
}
 
resource "aws_eip" "nat" {
  count = length(var.private_subnets)
  vpc = true
}


## ========================================
## Creating AWS private route table section
## ========================================
resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route" "private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = var.all_cidr
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}