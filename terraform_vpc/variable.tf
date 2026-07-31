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

variable  "cidr_block_private" {

     type = list
     default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable  "cidr_block_database" {

     type = list
     default = ["10.0.21.0/24","10.0.22.0/24"]
}

variable "public_subnets_tags" {
             type = map
             default = {}
}

variable "private_subnets_tags" {
             type = map
             default = {}
}

variable "database_subnets_tags" {
             type = map
             default = {}
}

variable "public_route_tags"{
       type = map
       default = {}
}

variable "private_route_tags"{
     type = map
     default = {}
}

variable "database_route_tags"{
     type = map
     default = {}
}

variable "ng_route_tags" {
      type=map
      default={}
}