# Variable block is self-explanatory, as it defines a variable that can be
# used to set values in Terraform configuration.

# These can be overridden during apply using -var flag (or in a .tfvars file).
variable "container_name" {
    description = "Mongodb_container_name"
    type = string
    default = "ExampleMongodbContainer"
}