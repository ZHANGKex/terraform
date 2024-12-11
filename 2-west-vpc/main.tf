#########################
#variable

variable "region_1" {
  type    = string
  default = "us-east-1"
}

variable "region_2" {
  type    = string
  default = "us-west-1"
}

variable "vpc_cidr_range_east" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnets_east" {
  type    = list(string)
  default = ["10.10.0.0/24", "10.10.1.0/24"]
}

variable "database_subnets_east" {
  type    = list(string)
  default = ["10.10.2.0/24", "10.10.3.0/24"]
}

variable "vpc_cidr_range_west" {
  type    = string
  default = "10.11.0.0/16"
}

variable "public_subnets_west" {
  type    = list(string)
  default = ["10.11.0.0/24", "10.11.1.0/24"]
}

variable "database_subnets_west" {
  type    = list(string)
  default = ["10.11.8.0/24", "10.11.9.0/24"]
}

######################################################
#providers

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  alias  = "east"
  region = var.region_1
}

provider "aws" {
  alias  = "west"
  region = var.region_2
}



######################################################
#data source

data "aws_availability_zones" "azs_east" {
  provider = aws.east
}

data "aws_availability_zones" "azs_west" {
  provider = aws.west
}

#######################################################
#resource

module "vpc_east" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name           = "prod_vpc_east"
  cidr           = var.vpc_cidr_range_east
  azs            = slice(data.aws_availability_zones.azs_east.names, 0, 2)
  public_subnets = var.public_subnets_east

  #database subnets
  create_database_subnet_group = true
  database_subnets = var.database_subnets_east
  database_subnet_group_tags = {
    subnet_type = "databse"
  }

  providers = {
    aws = aws.east
  }

  tags = {
    Environment = "prod"
    Region      = "east"
    Team        = "infra"
  }
}

module "vpc_west" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name           = "prod_vpc_west"
  cidr           = var.vpc_cidr_range_west
  azs            = slice(data.aws_availability_zones.azs_west.names, 0, 2)
  public_subnets = var.public_subnets_west

  #database subnets
  create_database_subnet_group = true
  database_subnets = var.database_subnets_west
  database_subnet_tags = {
    subnet_type = "database"
  }

  providers = {
    aws = aws.west
  }

  tags = {
    Environment = "prod"
    Region      = "west"
    Team        = "infra"
  }

}

################################################
#output

output "vpc_id_east" {
  value = module.vpc_east
}

output "vpc_id_west" {
  value = module.vpc_west
}