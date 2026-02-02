# Outputs block defines outputs given by terraform apply or output.
output "container_id" {
  description = "ID of MongoDB's Docker container"
  value       = docker_container.mongodb.id
}
