resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = local.final_vpc_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = local.final_ig_tags
}

resource "aws_subnet" "public" {
  count = length(var.cidr_block_public)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_public[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true
  
  tags = merge(
        local.common_tags,
        {
             Name= "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        },
        var.public_subnets_tags
  )
}

resource "aws_subnet" "private" {
  count = length(var.cidr_block_private)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_private[count.index]
  availability_zone = local.az_names[count.index]
 
  
  tags = merge(
        local.common_tags,
        {
             Name= "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
        },
        var.public_subnets_tags
  )
}

resource "aws_subnet" "database" {
  count = length(var.cidr_block_database)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_database[count.index]
  availability_zone = local.az_names[count.index]

  
  tags = merge(
        local.common_tags,
        {
             Name= "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        },
        var.database_subnets_tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(

        local.common_tags,
        {
            Name= "${var.project}-${var.environment}-public"
        },
        var.public_route_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(

        local.common_tags,
        {
            Name= "${var.project}-${var.environment}-private"
        },
        var.private_route_tags
  )
}


resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(

        local.common_tags,
        {
            Name= "${var.project}-${var.environment}-database"
        },
        var.database_route_tags
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = merge(

        local.common_tags,
        {
            Name= "${var.project}-${var.environment}-nat"
        },
        var.database_route_tags
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags =  merge(

        local.common_tags,
        {
            Name= "${var.project}-${var.environment}"
        },
        var.ng_route_tags
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id  = aws_nat_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count = length(var.cidr_block_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.cidr_block_private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table_association" "database" {
  count = length(var.cidr_block_database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}