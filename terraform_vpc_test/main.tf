module "vpc" {

      source = "../terraform_vpc"
      
      project = var.project
      environment = var.environment

}