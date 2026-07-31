variable "project" {

     type = string
}

variable "environment" {

     type = string
}

variable "vpc_tags" {

      type = map
      default = {}
}

variable "ig_tags" {

      type = map
      default= {}
}

variable  "cidr_block_public" {

     type = list
     default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "public_subnets_tags" {
             type = map
             default = {}
}