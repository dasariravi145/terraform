module "vpc" {

      source = "../../terraform_vpc"
      
      project = var.project
      environment = var.environment
      is_peering_connection = true
}
