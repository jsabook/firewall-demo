/*
instance_type
ami-0dee0f906cf114191 centos7

*/  
locals {
  json_data = jsondecode(file("../credentials.json"))
}
provider "aws" {
  access_key = local.json_data.accessKey
  secret_key = local.json_data.secretKey
  region     = local.json_data.regionId
  default_tags {
    tags     = {
      owner  = "wujiashuai"
    }
  }
}