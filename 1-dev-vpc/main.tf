# variables

variable "region" {
  type = string
  default = "us-east-1"
}

variable "vpc_cidr_range" {
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type = list(string)
  default = [ "10.0.0.0/24", "10.0.1.0/24" ]
}

variable "database_subnets" {
  type = list(string)
  default = [ "10.0.8.0/24", "10.0.9.0/24" ]
}

#providers

provider "aws" {
  version = "~>2.0"
  region = var.region
}

#data_sorce
data "aws_availability_zones" "azs" {}

#resource
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.33.0"

  name = "dev-vpc"
  cidr = var.vpc_cidr_range
  azs = slice(data.aws_availability_zones.azs.names, 0, 2)
  public_subnets = var.public_subnets

  #database subnets
  database_subnets = var.database_subnets
  database_subnet_group_tags = {
    subnet_type = "database"
  }

  tags = {
    Environment = "dev"
    Team = "infra"
  }
}

#outputs

output "vpc_id" {
  value = module.vpc.vpv_id
}

output "db_subnet_group" {
  value = module.vpc.database_subnet_group
}

output "public_subnets" {
  value = module.vpc.public_subnets
}