module "sg" {

       source = "../../terraform-aws-sg"
       Project = var.project
       Environment= var.environment
       sg_name ="mongodb"
       vpc_id = local.vpc_id
}