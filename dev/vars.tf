variable "env" {
  description = "The deployment environment (e.g., 'dev', 'prd'). Used for naming resources and tagging."
  type        = string
}
variable "owner" {
  description = "The name or ID of the team/individual responsible for this infrastructure."
  type        = string
}
variable "project" {
  description = "The name of the project this infrastructure belongs to (e.g.,   'ikerian-challenge')."
  type        = string
}
data "aws_caller_identity" "current" {} #to help terraform-docs to understand the Providers is using 