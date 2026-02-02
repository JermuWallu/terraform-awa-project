
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

resource "docker_image" "mongodb" { # resource type and name
  name         = "mongodb:8.2"
  keep_locally = false
}

resource "docker_network" "Db_network" {
  name = "database_network"
}

resource "docker_container" "mongodb" {
  name  = "mongodb_container"
  image = docker_image.mongodb.image_id

  ports {
    internal = 27017
    external = 27017
  }

  networks_advanced {
    name = docker_network.Db_network.name
  }

  # dont do this at prod
  env = [
    "MONGO_INITDB_ROOT_USERNAME=admin",
    "MONGO_INITDB_ROOT_PASSWORD=password"
  ]

  volumes {
    container_path = "/data/db"
    volume_name    = docker_volume.mongodb_data.name
  }
}

resource "docker_volume" "mongodb_data" {
  name = "mongodb_data"
}