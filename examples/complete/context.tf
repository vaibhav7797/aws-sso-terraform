
#Module      : label
#Description : This terraform module is designed to generate consistent label names and
#              tags for resources. You can use terraform-labels to implement a strict
#              naming convention.

module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  enabled     = var.enable
  name        = var.name
  repository  = var.repository
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  extra_tags  = var.extra_tags
}