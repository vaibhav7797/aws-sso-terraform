variable "account_assignments" {
  type = list(object({
    account             = string
    permission_set_name = string
    permission_set_arn  = string
    principal_name      = string
    principal_type      = string
  }))
}


#Module      : LABEL
#Description : Terraform label module variables.

variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "repository" {
  type        = string
  default     = "https://github.com/vaibhav7797/aws-sso-terraform"
  description = "Terraform current module repo"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = []
  description = "Label order, e.g. `name`,`application`."
}


variable "attributes" {
  type        = list(any)
  default     = []
  description = "Additional attributes (e.g. `1`)."
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "managedby" {
  type        = string
  default     = "anmol@clouddrove.com"
  description = "ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'."
}

variable "enable" {
  type        = bool
  default     = true
  description = "Enable or disable of elasticache"
}