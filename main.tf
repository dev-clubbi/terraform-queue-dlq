provider "aws" {
  region = var.region
}

terraform {
  experiments = [module_variable_optional_attrs]
}