
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker" # default source is Terraform Registry
      version = "~> 3.6.2"           # Optional but reccommended to avoid breaking changes (defaults to latest)
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine" # something Windows named pipe
}

# Create a private network for the containers to communicate
resource "docker_network" "private_network" {
  name = "private_network"
}

resource "docker_image" "mongodb" {
  name         = "mongodb:8.2"
  keep_locally = false
}
resource "docker_container" "mongodb" {
  name  = "mongodb_container"
  image = docker_image.mongodb.image_id

  ports {
    internal = 27017
    external = 27017
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  # dont do this at prod
  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=password"
  ]

# dunno if this is needed
  volumes {
    container_path = "/data/db"
    volume_name    = docker_volume.mongodb_data.name
  }
}

# dunno if this is needed
resource "docker_volume" "mongodb_data" {
  name = "mongodb_data"
}

# Backend (Server) Image and Container
resource "docker_image" "server" {
  name         = "awa-server:latest"
  keep_locally = true

  build {
    context    = "${var.awa_project_path}/server"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "server" {
  name  = "awa_server_container"
  image = docker_image.server.image_id

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  env = [
    "SECRET=your-secret-key-change-in-production",
    "PORT=3000",
    "NODE_ENV=development",
    "MONGODB_URI=mongodb://admin:password@mongodb_container:27017/kanban"
  ]

  # backend doesn't work without mongodb
  depends_on = [
    docker_container.mongodb
  ]
}

# Frontend (Client) Image and Container
resource "docker_image" "client" {
  name         = "awa-client:latest"
  keep_locally = true

  build {
    context    = "${var.awa_project_path}/client"
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "client" {
  name  = "awa_client_container"
  image = docker_image.client.image_id

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  # frontend depends on backend server
  depends_on = [
    docker_container.server
  ]
}