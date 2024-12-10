#######################################
# PROVIDERS
#######################################
provider "aws" {
    access_key = "ACCESS_KEY"
    secret_key = "SECRET_KEY"
    region = "us-east-1"
}

#######################################
# DATA
#######################################

data "aws_ssm_parameter" "amzn2_linux" {
    name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#######################################
# RESOUECES
#######################################

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id
}

resource "aws_subnet" "public_subnet1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.app.id
  map_public_ip_on_launch = true
}