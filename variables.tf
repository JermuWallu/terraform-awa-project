# Variable block is self-explanatory, as it defines a variable that can be
# used to set values in Terraform configuration.

# These can be overridden during apply using -var flag (or in a .tfvars file).
variable "container_name" {
    description = "Mongodb_container_name"
    type = string
    default = "ExampleMongodbContainer"
}

variable "mongodb_username" {
  description = "MongoDB root username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "mongodb_password" {
  description = "MongoDB root password"
  type        = string
  default     = "password"
  sensitive   = true
}

variable "awa_project_path" {
  description = "Path to the AWA project directory"
  type        = string
  default     = "../AWA-project-work"
}