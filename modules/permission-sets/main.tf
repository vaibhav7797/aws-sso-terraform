
#Module      : label
#Description : sso terraform module is designed to generate consistent label names and
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


# CREATE THE PERMISSION SETS

resource "aws_ssoadmin_permission_set" "sso" {
  for_each         = local.permission_set_map
  name             = each.key
  description      = each.value.description
  instance_arn     = local.sso_instance_arn
  relay_state      = each.value.relay_state != "" ? each.value.relay_state : null
  session_duration = each.value.session_duration != "" ? each.value.session_duration : null
  tags             = module.labels.tags
}


# ATTACH INLINE POLICIES

resource "aws_ssoadmin_permission_set_inline_policy" "sso" {
  for_each           = local.inline_policies_map
  inline_policy      = each.value
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso[each.key].arn
}


# ATTACH MANAGED POLICIES

resource "aws_ssoadmin_managed_policy_attachment" "sso" {
  for_each           = local.managed_policy_attachments_map
  instance_arn       = local.sso_instance_arn
  managed_policy_arn = each.value.policy_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso[each.value.policy_set].arn
}


# ATTACH CUSTOMER MANAGED POLICIES

resource "aws_ssoadmin_customer_managed_policy_attachment" "sso" {
  for_each           = local.customer_managed_policy_attachments_map
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.sso[each.value.policy_set].arn
  customer_managed_policy_reference {
    name = each.value.policy_name
    path = each.value.policy_path
  }
}




# LOCAL VARIABLES AND DATA SOURCES

data "aws_ssoadmin_instances" "sso" {}

locals {
  sso_instance_arn    = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  permission_set_map  = { for ps in var.permission_sets : ps.name => ps }
  inline_policies_map = { for ps in var.permission_sets : ps.name => ps.inline_policy if ps.inline_policy != "" }
  managed_policy_map  = { for ps in var.permission_sets : ps.name => ps.policy_attachments if length(ps.policy_attachments) > 0 }
  managed_policy_attachments = flatten([
    for ps_name, policy_list in local.managed_policy_map : [
      for policy in policy_list : {
        policy_set = ps_name
        policy_arn = policy
      }
    ]
  ])
  managed_policy_attachments_map = {
    for policy in local.managed_policy_attachments : "${policy.policy_set}.${policy.policy_arn}" => policy
  }
  customer_managed_policy_map = { for ps in var.permission_sets : ps.name => ps.customer_managed_policy_attachments if length(ps.customer_managed_policy_attachments) > 0 }
  customer_managed_policy_attachments = flatten([
    for ps_name, policy_list in local.customer_managed_policy_map : [
      for policy in policy_list : {
        policy_set  = ps_name
        policy_name = policy.name
        policy_path = policy.path
      }
    ]
  ])
  customer_managed_policy_attachments_map = {
    for policy in local.customer_managed_policy_attachments : "${policy.policy_set}.${policy.policy_path}${policy.policy_name}" => policy
  }
}
