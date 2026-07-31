resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
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