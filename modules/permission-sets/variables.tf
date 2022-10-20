variable "permission_sets" {
  type = list(object({
    name               = string
    description        = string
    relay_state        = string
    session_duration   = string
    inline_policy      = string
    policy_attachments = list(string)
    customer_managed_policy_attachments = list(object({
      name = string
      path = string
    }))
  }))

  default = []
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