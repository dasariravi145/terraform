locals {

      common_tags = {
           
             Project = var.project
             Environment = var.environment
             Terraform = "true"
      }

      final_vpc_tags = merge(
                local.common_tags,
                {
                    Name = "${var.project}-${var.environment}"
                },
                var.vpc_tags
      )
      final_ig_tags = merge(
                local.common_tags,
                {
                    Name = "${var.project}-${var.environment}"
                },
                var.ig_tags
      )

     az_names = slice(data.aws_availability_zones.available.names,0,2)

     
}