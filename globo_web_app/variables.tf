variable "company" {
  type = string
  description = "Company name for resource tagging"
  default = "Globomantics"
}

variable "project" {
  type = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type = string
  description = "Billing code for resource tagging"
}