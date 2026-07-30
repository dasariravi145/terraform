variable "project" {

     type = string
}

varibale "environment" {

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