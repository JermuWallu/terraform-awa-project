# Outputs block defines outputs given by terraform apply or output.
output "container_id" {
  description = "ID of MongoDB's Docker container"
  value       = docker_container.mongodb.id
}

output "server_container_id" {
  description = "ID of the backend server container"
  value       = docker_container.server.id
}

output "client_container_id" {
  description = "ID of the frontend client container"
  value       = docker_container.client.id
}

output "application_urls" {
  description = "URLs to access the application"
  # en tiiä toimiiko nää :D
  value = {
    frontend = "http://localhost:${docker_container.client.ports[0].external}"
    backend  = "http://localhost:${docker_container.server.ports[0].external}"
    mongodb  = "mongodb://localhost:${docker_container.mongodb.ports[0].external}"
  }
}
